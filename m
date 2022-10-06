Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51185F661A
	for <lists+stable@lfdr.de>; Thu,  6 Oct 2022 14:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbiJFMba (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Oct 2022 08:31:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiJFMb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Oct 2022 08:31:28 -0400
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B4D6243
        for <stable@vger.kernel.org>; Thu,  6 Oct 2022 05:31:26 -0700 (PDT)
Received: by mail-vs1-xe32.google.com with SMTP id x124so1790861vsb.13
        for <stable@vger.kernel.org>; Thu, 06 Oct 2022 05:31:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ndOW6y41ktlehU6CsRnU/VLJv1FLqyO446+s4fKHnr0=;
        b=SSvTs++pGu7iH8vS0Tr9frffp1/yj63HrhO3hRYxm8zghaq1uBT0f+dAL2DJPmCdME
         WVTI9t/+zZ+Diq3krcroMdS5s1ToFepAN8GIq4hBzbI0ZAEJWplNcY780lPAoUJP6IoN
         EO5qHQVvUghbOFMPcQuAIXT1b1+TGKxotvq/0Q0tqMEt2O0el2h/YiLH1oGeIJSPJyZH
         PiLEORMnSr3N0LiEIU6L0JPVYnA57eNILOnnkdkAcHzSEsimjbLiQaz4UpBmSzXa+2pR
         PfSRlAkOfJTQBJAC0FUtzOE7G09vHQCOu2gfl/i1Ds9At7gRUtoP1QKoQRJTJ+H2tPj7
         t2YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ndOW6y41ktlehU6CsRnU/VLJv1FLqyO446+s4fKHnr0=;
        b=c693HM/WgvWTZWXR0VIf/7hSqRfBB71/037/6QVm0IPqxI8UZI+NJnRgublxy1+2O+
         nbL/19XNTwlD+Sn4DlT3nwUMni5Itlz8T8d3hgyESON4TBS/hpYk4RmPuYaWE8vYkQs2
         7NUAvE73egKXIZnaDvrpgbNioufEyd3FjAvqRwnsExl+NLUYxqEYQANnTMjtQF78iOX+
         nLKDQ3BGI3nUQLNAmGxSVPidNhACR/YLdHqbS3QJvbQPebQeVdT24olBtBV5lAaRkVBb
         i5gZnFj0DLf0m36LLOWvULJltwnUICuFJKUKs1vTikgObh+VifZxQ1fUe2o1xKIysBNT
         NHwg==
X-Gm-Message-State: ACrzQf0s3Rh5fVfk/fX4TudLxo5jxNJVzuAdOmm+wCXZcMllZeeZCG3g
        M1NPjU/Rc8tTz76FFVPSxH7JE0fmMeilTlyAeFmXD7y86Vau0Q==
X-Google-Smtp-Source: AMsMyM79IUXKCvYeINarOUY6rytb62Mw6cmPrMee0XT9w5Vgvci+7DsEie8tU5EIsBYn18dCLmbnkiB51qIGyRgx+RQ=
X-Received: by 2002:a67:d60a:0:b0:3a6:5cf4:29d1 with SMTP id
 n10-20020a67d60a000000b003a65cf429d1mr2440227vsj.78.1665059485566; Thu, 06
 Oct 2022 05:31:25 -0700 (PDT)
MIME-Version: 1.0
From:   Jalal Mostafa <jalal.a.mostapha@gmail.com>
Date:   Thu, 6 Oct 2022 14:31:14 +0200
Message-ID: <CAFLwmnvU8Z7N=nckqwuXOsFBTJn-aJJUJ9aLR6eTQ-z+4JFzbQ@mail.gmail.com>
Subject: Merge into stable: xsk: inherit need_wakeup flag for shared sockets
To:     stable@vger.kernel.org
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

The following patch should be backported to the stable kernel versions
starting from 5.10
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=60240bc26114

The patch fixes inheriting the need_wakeup flag for AF_XDP sockets.
Sockets with XDP_SHARED_UMEM cannot have good performance because they
do not get this flag from the first socket.

Fixes: b5aea28dca134 ("xsk: Add shared umem support between queue ids")
Commit ID: 60240bc26114 ("xsk: Inherit need_wakeup flag for shared sockets")
Kernels: 5.10 - 5.15 - 5.19 - 6.0

Best Regards,
Jalal

P.S.: Sorry for receiving multiple copies of this email. TEXT/PLAIN
mode is enabled now.
