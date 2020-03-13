Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44B05184A44
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 16:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726479AbgCMPJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 11:09:52 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:37051 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbgCMPJw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 11:09:52 -0400
Received: by mail-ed1-f67.google.com with SMTP id b23so12295615edx.4
        for <stable@vger.kernel.org>; Fri, 13 Mar 2020 08:09:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kGmP5jBz5vbcJ9qpF1qcUuCMSkRXJVVgSvsvPN4/pvY=;
        b=YnIjawwSWXnPMqrluiZCo9wPLRJML/zsfavms5YhgfnfJfvpyw/pSv0dcAuaqX1pfp
         JTM9E9YBbDlYZAasj9g1X3E8aMQd4ciOqCTwEOlLaj9sav4s8KdKPpcGiNzqhdWAuX0p
         DUzLyN9WL1BflFN/L7Iq9mFkF3Vbyo7X020o1tuW4ARyqc1X61eGtywXJ9OGYY27TR00
         yPg9ja1iw12pmSTzTfWm6G1RaqGf7KUBgqfmlbDCFUH7I/pV4/8TJxaAP90pbIFC6OIm
         w6W/L9FMYSGejufJYmtSKS6hYVqVrsLCVj0HhebIe+bGxVw8vgU4n/XbB9FT8ri0wciI
         v2mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kGmP5jBz5vbcJ9qpF1qcUuCMSkRXJVVgSvsvPN4/pvY=;
        b=kakgBtJNEknZNs2bVOExC2oy2C6K3p/URzTnWCWqVexJZtVQWm8EdHTn/dc9jgfMI7
         2Q5tntn42+Wx6ehVP9iPyJ3dzbzZ+gedfZWGTTlpL3rrs/LrB/vuyMBhL3L1Hgc1bOlb
         1LPEFC+GT6RTg5RRw9GlLlYSEKvQgmFb23eb8A6ZNvQj52pXB6QQKfZZD+RlucZOwZsb
         RnFPe2KyP7u6hpch8JRplQUvW8SYxyrCuP5gTr8R+UWfCQbRT6ODsw51l/B2Zf8az/xl
         8ZDWs0isjGsmXIQBN7DqGCAKRG0KrwqUOs5hpmjGYiDhxk5IUggcVrIoQMPJOyXCk+Oa
         R7Zg==
X-Gm-Message-State: ANhLgQ2Rmwt3Ssub2/5mJ5ucVaUvVGL1xCl+9xn1Qxf03vv8xXmengx8
        5DeNWH0ckE488v7SgKmIodNPJbjRRH8ElzbtbTla+w==
X-Google-Smtp-Source: ADFU+vsyrRXkX1gN02HKuf7HzixqRBC6xDj2FqRX5109PPmUTo9BkwRmp51pAjDJF2fxO2L8lMYYelp2tLiyn9Xjvzk=
X-Received: by 2002:a17:906:3797:: with SMTP id n23mr11656595ejc.368.1584112190945;
 Fri, 13 Mar 2020 08:09:50 -0700 (PDT)
MIME-Version: 1.0
References: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
In-Reply-To: <CAN19L9Fi0h0wHOyY3zdAU4vX=J+T_3sVkL_wsq89W+RgF7gBxA@mail.gmail.com>
From:   Pavel Tatashin <pasha.tatashin@soleen.com>
Date:   Fri, 13 Mar 2020 11:09:40 -0400
Message-ID: <CA+CK2bCEtgvkG7jd3rm2gipKE6KQ4dzfgFGERoib5W-=pchDWw@mail.gmail.com>
Subject: Re: [PING] EFI/PTI fix not backported to 3.16.XX?
To:     ben.hutchings@codethink.co.uk
Cc:     stable <stable@vger.kernel.org>, Sasha Levin <sashal@kernel.org>,
        Martin Galvan <omgalvan.86@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

I have tested and it cherry-picks cleanly on 3.16. I do not see any
issues with backporting it to 3.16. Do you want me to send a patch for
review, or can you just cherry-pick 7ec5d87df34a to 3.16?

Thank you,
Pasha


On Fri, Mar 13, 2020 at 10:09 AM Martin Galvan <omgalvan.86@gmail.com> wrote:
>
> Hi all,
>
> I've been running some tests on Debian 8 (which uses a 3.16.XX
> kernel), and saw that my system would occasionally reboot when
> performing an EFI variables dump. I did some digging and saw that this
> problem first appeared in 4.4.110 and was fixed by Pavel Tatashin in
> commit 7ec5d87df34a. At the same time, 4.9.XX, 4.14.XX and mainline
> have commit 67a9108ed431, which also solves the issue. However, the
> 3.16 stable line doesn't seem to have either fix, and therefore the
> crash is still there.
>
> I don't know whether any distros use 3.16 other than Debian, but it'd
> still be good to have this fix backported as well.
