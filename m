Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9565364A9FD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 23:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231364AbiLLWLB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 17:11:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbiLLWLB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 17:11:01 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B86DAD95;
        Mon, 12 Dec 2022 14:10:59 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id r15so9159504qvm.6;
        Mon, 12 Dec 2022 14:10:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=W3fdnCIdYn0lJ4Mxo5yFAqKtt9U4L6f/X7A6g14xg8A=;
        b=WBE3mdrauA1fH2/P8EvrnWRt/RzNEL9q5gVfL193jYozk1EP0hH//vDL/LNtnPvYRF
         4W3RU+5pCzo1eKIn9JrYHA6g3cZKMcTxYY+JTLVhII51tHssqWYlkogLQenKeK6lmUOj
         65vES31846yd+TrWo1wmisWja15UWlcWjBm9mRkgioggJcbfm1nHeBZbumma2LNV0/U/
         ATPUIxMJjUKuvTUBX0FIIz5sgQ8k346FjETh4gUSZPbiC5IPcCoHZtU51LkyJIxlbpA5
         0y3g+aqvWHPiAL9E+GJGWaOtR44SLvnN7NDoNXyzHbHYcbp7qr9oO3Tp3dJ4WcdvyF8J
         8sEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W3fdnCIdYn0lJ4Mxo5yFAqKtt9U4L6f/X7A6g14xg8A=;
        b=r20QcrPKg4h0k+imBnQEkz4Pjp4ye9HViOM2tad2Vc3rBVnoW4Ax03yAfTyYWhLYXr
         cX4DzPQV/A3Xrg9EIoPIopnRq6r/JDd1ADt03vK5vyg9GynhdvZiCpjA1/fbKsl34R58
         +gBidrpKts3v9jltsLbvYFx7Dj8sOlZVNd3TsB7GMen5+JxtVpIPENZbVAK6G6CxegVq
         g2ScMRKNywa/iCI3PD4a90yg/J5k/Ga3nVNxGXDHby+E6vRecn0y6h2g6j3tIdtddUoe
         6qMxW7SlCxzsBcfwaQErNRXwFqFoQDrRhWQvzy7WySET9BRXn4+I2TtIKzzjfAOMLGm6
         sXZg==
X-Gm-Message-State: ANoB5pnl5PMExGstMwnxqo0hMoK6BrJcftlz5yc28+J6jmfB6B2n7mPn
        7FU073Zng5sVdf2Cr3E/9yoMOIXFd73SSw==
X-Google-Smtp-Source: AA0mqf6LocvbuaTbqVkLPJ10p9RI6uMqXaM8vyeDgq/Ge1dPWQPM3UXW/fbz9MTvMks2tNgA6v8GIA==
X-Received: by 2002:ad4:4bc2:0:b0:4bb:859f:b217 with SMTP id l2-20020ad44bc2000000b004bb859fb217mr23604024qvw.47.1670883058788;
        Mon, 12 Dec 2022 14:10:58 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id dt38-20020a05620a47a600b006b9c9b7db8bsm6458167qkb.82.2022.12.12.14.10.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 14:10:58 -0800 (PST)
Message-ID: <60723e86-dc4c-7506-2231-decc6e1bd29e@gmail.com>
Date:   Mon, 12 Dec 2022 14:10:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 4.9 00/31] 4.9.336-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221212130909.943483205@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221212130909.943483205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/12/22 05:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.336 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.336-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>      Linux 4.9.336-rc1
> 
> Dan Carpenter <error27@gmail.com>
>      net: mvneta: Fix an out of bounds check
> 
> Yang Yingliang <yangyingliang@huawei.com>
>      net: plip: don't call kfree_skb/dev_kfree_skb() under spin_lock_irq()
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: fix build warning
> 
> Zhang Changzhong <zhangchangzhong@huawei.com>
>      ethernet: aeroflex: fix potential skb leak in greth_init_rings()
> 
> YueHaibing <yuehaibing@huawei.com>
>      tipc: Fix potential OOB in tipc_link_proto_rcv()
> 
> Liu Jian <liujian56@huawei.com>
>      net: hisilicon: Fix potential use-after-free in hix5hd2_rx()
> 
> Liu Jian <liujian56@huawei.com>
>      net: hisilicon: Fix potential use-after-free in hisi_femac_rx()
> 
> Kees Cook <keescook@chromium.org>
>      NFC: nci: Bounds check struct nfc_target arrays
> 
> Dan Carpenter <error27@gmail.com>
>      net: mvneta: Prevent out of bounds read in mvneta_config_rss()
> 
> Valentina Goncharenko <goncharenko.vp@ispras.ru>
>      net: encx24j600: Fix invalid logic in reading of MISTAT register
> 
> Valentina Goncharenko <goncharenko.vp@ispras.ru>
>      net: encx24j600: Add parentheses to fix precedence
> 
> Wei Yongjun <weiyongjun1@huawei.com>
>      mac802154: fix missing INIT_LIST_HEAD in ieee802154_if_add()
> 
> Wang ShaoBo <bobo.shaobowang@huawei.com>
>      Bluetooth: 6LoWPAN: add missing hci_dev_put() in get_l2cap_conn()
> 
> Akihiko Odaki <akihiko.odaki@daynix.com>
>      igb: Allocate MSI-X vector when testing
> 
> Akihiko Odaki <akihiko.odaki@daynix.com>
>      e1000e: Fix TX dispatch condition
> 
> Xiongfeng Wang <wangxiongfeng2@huawei.com>
>      gpio: amd8111: Fix PCI device reference count leak
> 
> Ziyang Xuan <william.xuanziyang@huawei.com>
>      ieee802154: cc2520: Fix error return code in cc2520_hw_init()
> 
> ZhangPeng <zhangpeng362@huawei.com>
>      HID: core: fix shift-out-of-bounds in hid_report_raw_event
> 
> Anastasia Belova <abelova@astralinux.ru>
>      HID: hid-lg4ff: Add check for empty lbuf
> 
> Hans Verkuil <hverkuil-cisco@xs4all.nl>
>      media: v4l2-dv-timings.c: fix too strict blanking sanity checks
> 
> Adrian Hunter <adrian.hunter@intel.com>
>      mmc: sdhci: Fix voltage switch delay
> 
> Masahiro Yamada <yamada.masahiro@socionext.com>
>      mmc: sdhci: use FIELD_GET for preset value bit masks
> 
> Connor Shu <Connor.Shu@ibm.com>
>      rcutorture: Automatically create initrd directory
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: don't call kfree_skb() with interrupts disabled
> 
> Juergen Gross <jgross@suse.com>
>      xen/netback: do some code cleanup
> 
> Ross Lagerwall <ross.lagerwall@citrix.com>
>      xen/netback: Ensure protocol headers don't fall in the non-linear area
> 
> Srinivasa Rao Mandadapu <quic_srivasam@quicinc.com>
>      ASoC: soc-pcm: Add NULL check in BE reparenting
> 
> Kees Cook <keescook@chromium.org>
>      ALSA: seq: Fix function prototype mismatch in snd_seq_expand_var_event
> 
> Tomislav Novak <tnovak@fb.com>
>      ARM: 9251/1: perf: Fix stacktraces for tracepoint events in THUMB2 kernels
> 
> Johan Jonker <jbx6244@gmail.com>
>      ARM: dts: rockchip: fix ir-receiver node names
> 
> Sebastian Reichel <sebastian.reichel@collabora.com>
>      arm: dts: rockchip: fix node name for hym8563 rtc
> 
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

