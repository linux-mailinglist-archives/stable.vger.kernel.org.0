Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF24339810
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 21:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234661AbhCLUNs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 15:13:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234656AbhCLUNd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 15:13:33 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00DCAC061574
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:13:32 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id y1so8777092ljm.10
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:13:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=Q76sEA5F/SDYrm1dKeoa9hUkU5w8Nl0RJ8ME9yVFdDI=;
        b=aQimIMw113H2E+okuojuMP0KtVOM1V8NimOeB55XFWhHMaEDP71uKoVdRxb65Djwbl
         22EcQoyaf2rbLV6OBnTEYu+EBVlYT8dEfe6RILCxuh3vVif8SN7NbORz2d6ogGi0E9qb
         Se/EZ4Ck2WaqNLSYsMdNw+PDh3i6MShtEO9Z4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=Q76sEA5F/SDYrm1dKeoa9hUkU5w8Nl0RJ8ME9yVFdDI=;
        b=unBGOKhISIjVhmu6LnhdRIAxuFPu35Xke6oMxPpOBJ2m0PeaiaeZZ7vxaADXVSU0YJ
         xcJWIwiZw+qEzR2EzE9PFGQK+r7OgXDH7Z1DCK1ZUSoowtW0hf6VIVKYP2kcVIs1zRmZ
         wUhSECidp/sQRYJfPnraXVWZVCQ1kBoII/QgDx4t0MT2K3hr8pgcYqVDtv3MYluEEtH9
         zjtStTiAsJUl8d2Uj3fJywAJaIxCc9P7K8PvpMCqo3nr6AnwMOQW1qy7wvwV0a25sZab
         kKsE+zav5KU8HpbyQUqcqx4N0thxJ09vlJcMeiFUILWEhYFuUeX3aKJ9/jn9Aj8hGIqG
         j44Q==
X-Gm-Message-State: AOAM531FfdtkOFoFAh4n1WEh/nqQDsUpSR7k+GieBLsxgueD8auZhTlh
        VZ3d0ZlXw3E9A1eylFT/3+6IP5JzwwFT6w==
X-Google-Smtp-Source: ABdhPJyrxrQPfuklLFqQI002+5aiaayRVUv+EVifIj89CDbc2gtEYdkXaoEOqm7wAevRrlwHD6Yx8w==
X-Received: by 2002:ac2:5144:: with SMTP id q4mr542679lfd.145.1615580011118;
        Fri, 12 Mar 2021 12:13:31 -0800 (PST)
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com. [209.85.208.175])
        by smtp.gmail.com with ESMTPSA id q24sm2098717lji.40.2021.03.12.12.13.30
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 12:13:30 -0800 (PST)
Received: by mail-lj1-f175.google.com with SMTP id u4so8789659ljo.6
        for <stable@vger.kernel.org>; Fri, 12 Mar 2021 12:13:30 -0800 (PST)
X-Received: by 2002:a2e:a306:: with SMTP id l6mr3282274lje.251.1615580009848;
 Fri, 12 Mar 2021 12:13:29 -0800 (PST)
MIME-Version: 1.0
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 12 Mar 2021 12:13:14 -0800
X-Gmail-Original-Message-ID: <CAHk-=wghmDFk+Rhcx2mtBMZYWCMDi62T5BcH+gHzqVhpWwC_xw@mail.gmail.com>
Message-ID: <CAHk-=wghmDFk+Rhcx2mtBMZYWCMDi62T5BcH+gHzqVhpWwC_xw@mail.gmail.com>
Subject: Re: [linux-stable-rc CI] Test report for 4.19.181-rc1/x86
To:     hulkrobot@huawei.com, Samuel Zou <zou_wei@huawei.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Removed most participants, leaving Greg and stable ]

The new hulkrobot emails seem to not thread with the announcements any
more, which makes them much harder to follow.

I'm assuming more automation, without the manual step (added Samuel
Zou who apparently did that manual part before)

This one I'm reacting to because it has a failure case, which it would
be good to

 (a) either bisect the cause

or alternatively

 (b) at least have some manual checking for - is it a real new
failure, or a "the test machines were very busy and timed out", or
what

I love seeing all the test automation, but I feel this one could have
done better...

             Linus


On Fri, Mar 12, 2021 at 11:32 AM <hulkrobot@huawei.com> wrote:
>
> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-4.19.y
> Arch: x86
> Version: 4.19.181-rc1
> Commit: cf7e1fa20d45200b0dad0a561975f501373581bd
> Compiler: gcc version 7.3.0 (GCC)
> --------------------------------------------------------------------
> Failed cases :
> ltp quota_remount_test01
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4651
> succeed_num: 4650
> failed_num: 1
> timeout_num: 1
> --------------------------------------------------------------------
> Tested-by: Hulk Robot <hulkrobot@huawei.com>
