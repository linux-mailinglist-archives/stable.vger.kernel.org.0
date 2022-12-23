Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E339655411
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 21:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230460AbiLWUBZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 15:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiLWUBY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 15:01:24 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606B360E6
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 12:01:23 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id c14so3808712qvq.0
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 12:01:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=T/HZO1Z86a/yucKbo8fCYB94xGQsaTO4ihOAnJOljMUc9OICiF/xMdXrc4ryg28DpR
         eFl/E3g3ID+1rnnglCWSW0jyixUPXe1uLYogNis+p2d9rOzDyOEgoIH4uPfAhY1MCiEh
         FRVU9oEHU2CS0vZvFc4uxoQNQVaMpW4BUYnLw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ytlGRN+Zvf1GCedPeHeIV0/Bc2Bxmm4MYRgni7UZ0VA=;
        b=3cfc2MinMqkjiHRPibcBgkn8omHo5dxfQwJ3cp2UMfruIWewzZsBL6VFD9nPv2++vm
         IKih+iyekJ16Bz4L6L2ii0tcwssffmKH6mU+AA/U0SY0qspBleO1+akuuBT10K2bvIzK
         /2yQeE5s4C8jfFoMToBsaBmSv0eFmTk7Zf5Veh12iyvahLQaDKzN46wWOMeQ2m1G6CV7
         ULqS5EfcVCjXVK6yNUPZLW59MHEocdaSYAkAQfM5TGNWNfncpUh63VHzDUKky2TV+/Gw
         K+nLtBdgZmhQIAAt0106VgaW8vDsZwIgRPPuGo188zcvnQeqFYzOjaOs//247epmne1+
         /j/A==
X-Gm-Message-State: AFqh2koNhFM2xaF4b+BFLGnua8nqo+yyZNE3AwpB88kGOAKNd4nNGevk
        zmEBCVjWSoUBzJaMSVk2Q5dw/E/6pZGXPGU/
X-Google-Smtp-Source: AMrXdXsIEo0nDrBAl3+LJ97PzIrkEd5KZztL0wb71gb09kMhhMoT6I9A8CBZw6cO6txGVynwS55oYA==
X-Received: by 2002:ad4:5f07:0:b0:4e8:595c:8009 with SMTP id fo7-20020ad45f07000000b004e8595c8009mr21383284qvb.24.1671825681429;
        Fri, 23 Dec 2022 12:01:21 -0800 (PST)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com. [209.85.219.53])
        by smtp.gmail.com with ESMTPSA id d8-20020a05620a158800b006fcaa1eab0esm2788586qkk.123.2022.12.23.12.01.21
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Dec 2022 12:01:21 -0800 (PST)
Received: by mail-qv1-f53.google.com with SMTP id d2so3754284qvp.12
        for <stable@vger.kernel.org>; Fri, 23 Dec 2022 12:01:21 -0800 (PST)
X-Received: by 2002:a05:6214:2b9a:b0:4c7:20e7:a580 with SMTP id
 kr26-20020a0562142b9a00b004c720e7a580mr551504qvb.43.1671825298226; Fri, 23
 Dec 2022 11:54:58 -0800 (PST)
MIME-Version: 1.0
References: <20221222144343-mutt-send-email-mst@kernel.org>
In-Reply-To: <20221222144343-mutt-send-email-mst@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri, 23 Dec 2022 11:54:41 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
Message-ID: <CAHk-=wi6Gkr7hJz20+xD=pBuTrseccVgNR9ajU7=Bqbrdk1t4g@mail.gmail.com>
Subject: Re: [GIT PULL] virtio,vhost,vdpa: features, fixes, cleanups
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        almasrymina@google.com, alvaro.karsz@solid-run.com,
        anders.roxell@linaro.org, angus.chen@jaguarmicro.com,
        bobby.eshleman@bytedance.com, colin.i.king@gmail.com,
        dave@stgolabs.net, dengshaomin@cdjrlc.com, dmitry.fomichev@wdc.com,
        elic@nvidia.com, eperezma@redhat.com, gautam.dawar@xilinx.com,
        harshit.m.mogalapalli@oracle.com, jasowang@redhat.com,
        leiyang@redhat.com, lingshan.zhu@intel.com, lkft@linaro.org,
        lulu@redhat.com, m.szyprowski@samsung.com, nathan@kernel.org,
        pabeni@redhat.com, pizhenwei@bytedance.com, rafaelmendsr@gmail.com,
        ricardo.canuelo@collabora.com, ruanjinjie@huawei.com,
        sammler@google.com, set_pte_at@outlook.com, sfr@canb.auug.org.au,
        sgarzare@redhat.com, shaoqin.huang@intel.com,
        si-wei.liu@oracle.com, stable@vger.kernel.org, stefanha@gmail.com,
        sunnanyong@huawei.com, wangjianli@cdjrlc.com,
        wangrong68@huawei.com, weiyongjun1@huawei.com,
        xuanzhuo@linux.alibaba.com, yuancan@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 11:43 AM Michael S. Tsirkin <mst@redhat.com> wrote:
>
>   https://git.kernel.org/pub/scm/linux/kernel/git/mst/vhost.git tags/for_linus

I see none of this in linux-next.

               Linus
