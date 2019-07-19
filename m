Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 715C36EAFD
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 21:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728802AbfGSTXO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 15:23:14 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:40352 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728247AbfGSTXO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Jul 2019 15:23:14 -0400
Received: by mail-pf1-f193.google.com with SMTP id p184so14581489pfp.7;
        Fri, 19 Jul 2019 12:23:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=o5xCvSlnXlBxg+m0uaArpKDa+hwImALNS5XibVt3aNU=;
        b=n/EcOcff15JbZzkCe7RV6+xrIaDmirK1MtBZ1xNzyViOTRd7WizzTaaHmy2w0vYWza
         J1cjauc1mrtjVrAjcr7BizKox1WdiKxWALH4rmZDm8pVTjcJhQBvPdKb1AT4LpBJuWNb
         Yueg05TX44C6uo/TL5ddF1jEfRzMS3+jNpt3JdgjrzveKyvytHwynFavAMV4HPBDqPW1
         R+AZ3EkvbydwkWrAbwYDgatPzfTFC8Yv9fO4MR6mBpIqyKprCOPz2v610SwwhTH1pIUl
         lweFh9vFpIK5kzSgfATPM+A166RpkbpP5NcX8A92lNLJS8Snpu+DAZ1jSZMZHdjJbpyV
         gf+Q==
X-Gm-Message-State: APjAAAWpm7K7vGxcQ6PBu+s15cbCPxbE+Lle+oK+LOxyk9A+ix16aHhA
        w02ZqIldL7OQfGZOvRunk+s=
X-Google-Smtp-Source: APXvYqwwS9v+M0BjUuFZ6AlES3mTtcXNhJb/6FWy3jTuB4wl+PXXyhMBzXCOSSRB/lgAZ85icuHJfQ==
X-Received: by 2002:a63:f953:: with SMTP id q19mr55519303pgk.367.1563564193260;
        Fri, 19 Jul 2019 12:23:13 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id 22sm36574639pfu.179.2019.07.19.12.23.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 12:23:12 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 4B725402A1; Fri, 19 Jul 2019 19:23:11 +0000 (UTC)
Date:   Fri, 19 Jul 2019 19:23:11 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com
Subject: Re: [PATCH 0/9] xfs: stable fixes for v4.19.y - circa ~ v4.19.58
Message-ID: <20190719192311.GP30113@42.do-not-panic.com>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 18, 2019 at 11:06:08PM +0000, Luis Chamberlain wrote:
> There is a stable bug tracking this, kz#204223 [1], and a respective bug
> also present on upstream via kz#204049 [2] which Zorro reported. But,
> again, nothing changes from the baseline.

The crash is fixed by Brian's commit 6958d11f77d ("xfs: don't trip over
uninitialized buffer on extent read of corrupted inode") merged on v5.1.

As such I'll extend this series to include one more patch.

  Luis
