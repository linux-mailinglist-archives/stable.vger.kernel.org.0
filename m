Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8A7D11478B
	for <lists+stable@lfdr.de>; Thu,  5 Dec 2019 20:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729145AbfLETTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Dec 2019 14:19:14 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:43579 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729022AbfLETTN (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Dec 2019 14:19:13 -0500
Received: by mail-qk1-f196.google.com with SMTP id q28so4290951qkn.10
        for <stable@vger.kernel.org>; Thu, 05 Dec 2019 11:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=X8Tp/XdEXs+TR5v+c9/suhk5h4IbR9LUYJcwVVfa/Uw=;
        b=ZX6PGbbxLe5/+H4/x+2ZwhNRSL/jP669CQcGGWDNfkkAp8vql6U0uYnfE+QF3sTNPv
         ExWqhN1gwNF37jPk7G6+k1S5kUO3VRteOuRzWzoejOtvD4hlOjgSANzsdOEnwtpoPWP2
         loOo30hlBIleoDQCDU4y3hF0EO+ggo42JD7IEY1LQ3sXyG2NGfunBUTncU2dCY3lVDSI
         gtynwEONEhLRiHaSOHJOTEorCytRJRJ5RoRTkfc0MAqPEOyDtimybJOX+nJszIUXokJX
         hkMRmmbU/uLOAZCR+LXJJjZ1B43W3JGvA69m//0OFwTn4AdK/9bKfGlfduMjV9HgiJVC
         yr7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=X8Tp/XdEXs+TR5v+c9/suhk5h4IbR9LUYJcwVVfa/Uw=;
        b=TCJbX1Pvaf8q6mJXkH35eRi5ycKLbKpy/IzHFbNvKYm41DKT7PLxg1+61RD7chq6ZO
         Vtl5BZkR0f6gZeDB/kMcKFzpSNlxDIzgvxSahDOe38LtsYyhAf5OFK6uoYgJv8UcXfyw
         ZFRZ7TheLrhjbR/GbkS0tGLQfIZTDzGfKkpqatZEbcdUGNYYtZ+2B8YTVEGUHLGzKht2
         1Xrv2TcYZNYqnR+IpPR6ypqyLo9+WHrE7jJGyz0PHNbZmJddVgNIZuZ0oGRmhQFyFRHK
         sQby26//fil5cD1lK2IYT0LYcep4kdPLPzXYR0cSiIeVfLnJ+HF1zNfc+73LFwW7nZrH
         3Fjg==
X-Gm-Message-State: APjAAAVDf+GUd8YQVSNf0Je/jP9ODkDC5IYLV1G5oz/Ey1flWubM/Z6P
        7iubCn/NfbWyV8IbGjSLhF3B98z85ZPOyQ==
X-Google-Smtp-Source: APXvYqxARhrKeQEoDRAu0FLed91qByNWJosnqUpmhhkBLUwPDj/7VnH8zVcJgktfsRT/sMody/3aBA==
X-Received: by 2002:a37:a348:: with SMTP id m69mr10474834qke.474.1575573550513;
        Thu, 05 Dec 2019 11:19:10 -0800 (PST)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id a63sm5180161qkd.37.2019.12.05.11.19.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Dec 2019 11:19:09 -0800 (PST)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [v3 PATCH] mm: move_pages: return valid node id in status if the page is already on the target node
Date:   Thu, 5 Dec 2019 14:19:08 -0500
Message-Id: <0E1D1C04-5892-438F-9191-F23CBE1A6DC5@lca.pw>
References: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
Cc:     fabecassis@nvidia.com, jhubbard@nvidia.com, mhocko@suse.com,
        cl@linux.com, vbabka@suse.cz, mgorman@techsingularity.net,
        akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
In-Reply-To: <1575572053-128363-1-git-send-email-yang.shi@linux.alibaba.com>
To:     Yang Shi <yang.shi@linux.alibaba.com>
X-Mailer: iPhone Mail (17B111)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



> On Dec 5, 2019, at 1:54 PM, Yang Shi <yang.shi@linux.alibaba.com> wrote:
>=20
> This is because the status is not set if the page is already on the
> target node, but move_pages() should return valid status as long as it
> succeeds.  The valid status may be errno or node id.
>=20
> We can't simply initialize status array to zero since the pages may be
> not on node 0.  Fix it by updating status with node id which the page is
> already on.

This does not look correct either.

=E2=80=9CENOENT
No pages were found that require moving. All pages are either already on the=
 target node, not present, had an invalid address or could not be moved beca=
use they were mapped by multiple processes.=E2=80=9D

move_pages() should return -ENOENT instead.=
