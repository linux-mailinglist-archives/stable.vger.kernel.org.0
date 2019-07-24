Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E9B87302C
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 15:46:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfGXNqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 09:46:49 -0400
Received: from mail-yb1-f194.google.com ([209.85.219.194]:37715 "EHLO
        mail-yb1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbfGXNqs (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 09:46:48 -0400
Received: by mail-yb1-f194.google.com with SMTP id i1so9995861ybo.4;
        Wed, 24 Jul 2019 06:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1FS6nZvEuFeNf1N3HWdad/uGLOLIg9Tz6qvhWMi6r5Y=;
        b=kC7amnJXE0zXukFis2aMFEVoF2p7S3Bhseme9BxEy0ua0iMlZ0MG/bVxXoa3licq+j
         vBDYMTBcVzXqD76FogQYucNOF/NuIcVP06M1OKip6pIwcmzqWIS2xtvdN/YhCrv5karB
         kwagT21FvJiVkLPHVCxmXltgEC75uOUdqHGpxks9V1Iqh9vu2shsYSUA2AXVA9QsswOF
         5Qhp8ofwrmImb4SUhZD5Uz9fD394qf8Q6b8rZ/NRTCbC9GRRwHVCfyAYv7PNNCr1ODgK
         NOocIcgphcfuruoN+JA/+QJ2aSftTmR9kD1mHQPVOjnzVINpqYb/sv3gOrVoeYMwIF6s
         BSJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1FS6nZvEuFeNf1N3HWdad/uGLOLIg9Tz6qvhWMi6r5Y=;
        b=DPZzxeni8VKKseAQlsMx7naIEH0etHJfLxNZHEsFbcaA2gxwVPDeSVjFz775quFi7w
         arWxzGm0OWlgA+B6R0NnXnMZXNPd51ReJQLSwBZWeEbkahoMM996ns/lqM+oztA+EPvH
         0Tnep14c49yl9GAbBYO+VEFeeiMYBvPDEtYkUumnhQNt94dOhjCEHDB2ROWQF8hfn2o5
         Ls1xmrZBlRAyw1Xou/0L0LgtKMA+tjiCHkZMalocOsGa9EpJAarv7OAbzc/FWIBqRf+O
         gNnog/sUsyDsNGH7iRKy5m5OJ226Zqe7ow7o2/ZWwRTUIQWrDnw2Hp/tfxGOHzrc4wsN
         Sh5w==
X-Gm-Message-State: APjAAAWWTnhRqSkwZpYnRXGZ6G5JcDpvt3L6W1IirE5n9H+BOIjN4wtL
        GEob+RdzzmFMaKPeBmANJPzq/DF4JymD9MhD+0M=
X-Google-Smtp-Source: APXvYqzXdM5vKUUQadLuXZMsw7VWFLPbI51DNM7UMxQWu7FfUIu4B/2OC+v63bBoANlhjRNfXBm/oiteq5h9+LMmhHI=
X-Received: by 2002:a25:aaea:: with SMTP id t97mr48822748ybi.126.1563976007886;
 Wed, 24 Jul 2019 06:46:47 -0700 (PDT)
MIME-Version: 1.0
References: <1560073529193139@kroah.com> <CAOQ4uxiTrsOs3KWOxedZicXNMJJharmWo=TDXDnxSC1XMNVKBg@mail.gmail.com>
 <CAOQ4uxiTTuOESvZ2Y5cSebqKs+qeU3q6ZMReBDro0Qv7aRBhpw@mail.gmail.com>
 <20190623010345.GJ2226@sasha-vm> <20190623202916.GA10957@kroah.com>
 <20190624003409.GO2226@sasha-vm> <CAOQ4uxiz5CkGojr5yquUd__TS_eae+ZapqyGaojiOUGniFPMsg@mail.gmail.com>
 <20190724115714.GA3244@kroah.com>
In-Reply-To: <20190724115714.GA3244@kroah.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 24 Jul 2019 16:46:36 +0300
Message-ID: <CAOQ4uxiEVsBp6qojO9K1TqzpETtdqDPzqTaFQGjr8woJ2WQP=g@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] ovl: support the FS_IOC_FS[SG]ETXATTR
 ioctls" failed to apply to 5.1-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        stable <stable@vger.kernel.org>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > I don't think syzkaller ones are more relevant to 5.1 then the rest of
> > the patches applied to 4.19. If anything, its the other way around.
> > According to syzbot dashboard, it is being run on LTS kernels, not on
> > latest stable.
> >
> > Please forgive me if my language caused confusion, when I said
> > "please apply to 4.19" I meant 4.19+.
>
> So is anything else needed to be done here, or are we all caught up and
> everything merged properly?
>

All the needed patches have been merged, but
Upstream commit 146d62e5a5867fbf84490d82455718bfb10fe824
("ovl: detect overlapping layers") did introduce a regression to
docker and friends into stable kernels :-/

The fix commit is already tested and waiting in linux-next:
0be0bfd2de9d ("ovl: fix regression caused by overlapping layers detection")
but did not hit upstream yet. When it does, will need to apply it to v4.19+

Thanks,
Amir.
