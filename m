Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF6611E7D19
	for <lists+stable@lfdr.de>; Fri, 29 May 2020 14:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbgE2MYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 May 2020 08:24:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725306AbgE2MYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 May 2020 08:24:52 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22D91C03E969
        for <stable@vger.kernel.org>; Fri, 29 May 2020 05:24:51 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id o9so2359957ljj.6
        for <stable@vger.kernel.org>; Fri, 29 May 2020 05:24:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=MN+UUBISdsNTDDmehVe1cK2X238KUuSmmp/jBBjzJ3E=;
        b=OsNK7LXwflk9du9iEfXHU7+wNNfBePZgb2MgJnh4ErszSsKgUyINHj8lylD5Z4ZAHx
         1loJ1lLKSqKhA1Q2NHWpOZ+GFV+VLZ3eugiliM9O6gCRYy49pdZfPLN5iCud2xs6P0Nz
         cGGnHSTDjGcOOElG/1fzJlZJLT0Yy/z+4ibxa7Fy4ak3kgqMymrxHCfUDMMKNsuZpZ9s
         ZzHfwXK2Q29tMJj0OmTAPOUrkzeFJC4F9R9Zh52rAaNAYDKF2KLfqw0HjllILYD9YgvY
         Aa/5tyoW2YXBNjfbkV6lqY5IVm/K+1koRLKN75QpLR8uyW3QUt6ns/O+pN9qM94sk+uj
         5Mcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=MN+UUBISdsNTDDmehVe1cK2X238KUuSmmp/jBBjzJ3E=;
        b=GZH7en5neZmyH0O5nBJdfyJB3IzYb9uIn0uhayuzYshDaNSvZXTah4mRAKZ8UPDfxg
         g13gf+4FHihHUQ5zZkbKIorQXwjQVKtuF/VPzJAa4POUCeTlCELEtcvWE+yHG5yRHCxx
         Yj3++1/QelqMj9avXdQG5VXGXQMo6upLpSXONGHXAoTUcdPQJ0DM3+xaW5WX8ldhD20G
         O6XLcdjDOnlEuDuMtr5mIFO+BCpYsjEGvU8khEg6Qne4ZjoPdNY/PmPH3PgKQCypL27O
         7xS3+zK4jg/Sab7MARgxEqPpKXdnSWLsdE65lfjX5BoiImsllnKllfjewXqm9oFZ6ujA
         O82w==
X-Gm-Message-State: AOAM5330ktgLGKld8TMekw6K7B3/64irRXQ107819Cuwj8rGp0jTjsdN
        gxZmtbhINkB0eacRN+weJ47jIX7kSsU=
X-Google-Smtp-Source: ABdhPJzsau1itA6h14w53xS9D3BJ7i0RuVQMEMQpaN27PBudXW6YbsJXPGb8kmJoIGPYUz8zaRNN0g==
X-Received: by 2002:a2e:b8c2:: with SMTP id s2mr4377215ljp.368.1590755089307;
        Fri, 29 May 2020 05:24:49 -0700 (PDT)
Received: from buimax ([109.204.208.150])
        by smtp.gmail.com with ESMTPSA id i8sm2546186lfl.72.2020.05.29.05.24.48
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 May 2020 05:24:49 -0700 (PDT)
Date:   Fri, 29 May 2020 15:24:47 +0300
From:   Henri Rosten <henri.rosten@unikie.com>
To:     stable@vger.kernel.org
Cc:     lukas.bulwahn@gmail.com, gregkh@linuxfoundation.org
Subject: Patches potentially missing from stable releases
Message-ID: <20200529122445.GA32214@buimax>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We did some work on analyzing patches potentially missing from stable 
releases based on the Fixes: and Revert references in the commit 
messages. Our script is based on similar idea as described by Guenter 
Roeck in this earlier mail: 
https://lore.kernel.org/stable/20190827171621.GA30360@roeck-us.net/.

Although the list is not comprehensive, we figured it makes sense to 
publish it in case the results are of interest to someone else also.

The below list of potentially missing commits is based on 4.19, but some 
of the commits might also apply to 5.4 and 5.6.

For each potentially missing commit flagged by the script, we read the 
commit message and had a short look at the change. We then added 
comments on our own judgement if it might be stable material or not. No 
comments simply means the potentially missing patch appears stable 
material. "Based on commit" is the mainline patch that has been 
backported to 4.19 and is referenced by the missing commit. We did not 
check if the patch applies without changes, nor did we build or execute 
any tests.


6011002c1584    uio: make symbol 'uio_class_registered' static
    Based on commit: ae61cf5b9913

968339fad422    powerpc/boot: Delete unneeded .globl _zimage_start
    Based on commit: ee9d21b3b358
    Comment: not stable material?

ed4d81c4b3f2    net: aquantia: when cleaning hw cache it should be toggled
    Based on commit: 7a1bb49461b1
    Comment: this was backported to 5.3, but for some reason not to 
    older stable releases

b27507bb59ed    net/ibmvnic: unlock rtnl_lock in reset so linkwatch_event can ru
    Based on commit: a5681e20b541

61c347ba5511    afs: Clear AFS_VNODE_CB_PROMISED if we detect callback expiry
    Based on commit: ae3b7361dc0e
    Comment: likely requires manual backport

1a49b2fd8f58    kbuild: strip whitespace in cmd_record_mcount findstring
    Based on commit: 6977f95e63b9
    Comment: not stable material?

669e859b5ea7    btrfs: drop the lock on error in btrfs_dev_replace_cancel
    Based on commit: d189dd70e255
    Comment: earlier backport failed, this would likely require manual 
    backport: https://lore.kernel.org/stable/15531096685894@kroah.com/

dddaf89e2fbc    netfilter: ipt_CLUSTERIP: make symbol 'cip_netdev_notifier' stat
    Based on commit: 5a86d68bcf02

01091c496f92    acpi/nfit: improve bounds checking for 'func'
    Based on commit: 11189c1089da
    Comment: the missing commit was picked by AUTOSEL to 5.4, 5.5, and 
    5.6, but for some reason, it was not backported 4.19: 
    https://lore.kernel.org/stable/?q=01091c496f92*

2b74c878b0ea    IB/hfi1: Unreserve a flushed OPFN request
    Based on commit: ca95f802ef51
    Comment: earlier backport failed, this would likely require manual 
    backport: https://lore.kernel.org/stable/15649835016938@kroah.com/

0b815023a1d4    bnxt_en: Fix ring checking logic on 57500 chips.
    Based on commit: 36d65be9a880
    Comment: likely requires manual backport

6ae865615fc4    x86/uaccess: Dont leak the AC flag into __put_user() argument ev
    Based on commit: 2a418cf3f5f1
    Comment: commit 9b8bd476e78e which mentions complementing 
    6ae865615fc4, has already been backported to 4.19

70db5b04cbe1    f2fs: give some messages for inline_xattr_size
    Based on commit: 500e0b28ecd3
    Comment: not stable material?

2a06b8982f8f    net: reorder 'struct net' fields to avoid false sharing
    Based on commit: 355b98553789
    Comment: this was backported to 5.3, but for some reason not to 
    older stable releases

0fbf21c3b36a    ALSA: hda/realtek - Enable micmute LED for Huawei laptops
    Based on commit: 8ac51bbc4cfe
    Comment: not stable material?

Thanks,
-- Henri

