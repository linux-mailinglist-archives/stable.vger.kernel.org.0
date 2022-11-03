Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1F8161874F
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 19:19:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231472AbiKCSTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 14:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiKCSTQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 14:19:16 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA6FD13DDA
        for <stable@vger.kernel.org>; Thu,  3 Nov 2022 11:19:15 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id e15so1700745qvo.4
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 11:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=aN3dMnVz+nmi7TLCuQg/8KIQmgzCsYAurRu4UYTuXBY=;
        b=fkpYqygolTBusc2DhAgbyGqcJqlfl8mbO4AbHfABXcbAM6YMQWzQ83rV+/tM3/ISaG
         08ugJjJGFwLe9eNtMFK6EXJ8L/NlLdvWPOa5ylDcykJiBMPo6ueo7dPQew4puJ97dsU4
         IAszUjG77JXeR4gcMzJhogfvbJFO+FBRNhlR0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aN3dMnVz+nmi7TLCuQg/8KIQmgzCsYAurRu4UYTuXBY=;
        b=TyxRB/DOKmo7jLFUXucouQ3r5wa7t8t/U7ED40FJ+P5TJ0l3OOAt65zdIHy/bBOq/a
         qGX38odT7zEr7Q4yP1VxmFXq2Dy/e2/AtU+IBrjihMGTZHC/NumjdBUTXVuD9c3MvV9H
         hS6di2QOzvN0AISuDSRna/lGUa+kaGhAOMcQPlUi7oVVPByROmeJM+64KsbuEf7Qd9nq
         Nx9//pbXqdNjpDa692auhXAdrMOjNWpagoc71gtVNp2+V6m1Jp0RBZLdI1s8jDQ1DatD
         A6pwTaVPu52CV0AeMkFFps5nziBpgedIxJ57klO7Dc55xNLBvDZgAmlEzIebTr5SC7B6
         luqQ==
X-Gm-Message-State: ACrzQf1Rf409pKGoPrl0rkim5QMe/4D1ZxJQkVc3UZJe+1IIT/Lahn4n
        dxznXpx9Z2XdNP1/Z+t4uLOhe35CCMtMPw==
X-Google-Smtp-Source: AMsMyM5QDY5/3taduGoo3xDHQrAbZnBcbfZsvFGMRn1kfEURRUYFor5lms+4i19zTfzWabkpUKBjBg==
X-Received: by 2002:ad4:4eeb:0:b0:4bb:f8cd:a5b0 with SMTP id dv11-20020ad44eeb000000b004bbf8cda5b0mr20736947qvb.123.1667499554695;
        Thu, 03 Nov 2022 11:19:14 -0700 (PDT)
Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com. [209.85.219.53])
        by smtp.gmail.com with ESMTPSA id s9-20020a05620a29c900b006cec8001bf4sm1219716qkp.26.2022.11.03.11.19.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Nov 2022 11:19:14 -0700 (PDT)
Received: by mail-qv1-f53.google.com with SMTP id c8so1687353qvn.10
        for <stable@vger.kernel.org>; Thu, 03 Nov 2022 11:19:13 -0700 (PDT)
X-Received: by 2002:ad4:4ea3:0:b0:4bb:6b59:9785 with SMTP id
 ed3-20020ad44ea3000000b004bb6b599785mr27117519qvb.118.1667499553629; Thu, 03
 Nov 2022 11:19:13 -0700 (PDT)
MIME-Version: 1.0
From:   Khazhy Kumykov <khazhy@chromium.org>
Date:   Thu, 3 Nov 2022 11:19:02 -0700
X-Gmail-Original-Message-ID: <CACGdZYJajC76+92imPwBHUFcYQLmJKkX2xjjpoTvhgH=v9+JZg@mail.gmail.com>
Message-ID: <CACGdZYJajC76+92imPwBHUFcYQLmJKkX2xjjpoTvhgH=v9+JZg@mail.gmail.com>
Subject: bfq fix for missing lock
To:     stable@vger.kernel.org
Cc:     Yu Kuai <yukuai3@huawei.com>, Jan Kara <jack@suse.cz>,
        Chaitanya Kulkarni <kch@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please consider backporting 181490d5321806e537dc5386db5ea640b826bf78
("block, bfq: protect 'bfqd->queued' by 'bfqd->lock'"), which was
merged in 5.19

applies cleanly to the lts trees I have (4.14 - 5.15), glancing at the
git history it looks like this bug has been present since bfq was
introduced in 4.14ish, so the above stables should be enough.
