Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C0AD95E7ADC
	for <lists+stable@lfdr.de>; Fri, 23 Sep 2022 14:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiIWMfJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Sep 2022 08:35:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIWMfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Sep 2022 08:35:08 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48E494122
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 05:35:04 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id j16so88675lfg.1
        for <stable@vger.kernel.org>; Fri, 23 Sep 2022 05:35:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=R1XJTYwA9rZTm20kUJO47vIgsaq5Ujs8OtaAarvQRMU=;
        b=Sxt3BtPK4m4cJcmU00DseClhNDGthyCubw6Fcvd2cMwXSUUYBvQqnjZVYKzNBG5clm
         r9LQ2p4malqoD31uK5f6RW420788rPn8Ph+oQMRp6DPHIBTwBOgIAfCfAPjqE0amw8h6
         +g7VuQhLnLgCvAcDg3gu2DoBTHruTU439zzOuQH5TrskYLZEze/Oj5fYho0kBzhNo3DA
         /tS9MsCrAF+Ac57LbZcEf5IsGP0IDRmjImYxnmdv1udD6fL2WNLNYau6C33MHct68BT7
         rfNWHcnvFAdRKx9tFf4Z6vUyzD2zQlM2OiLPN9RqXF+HN42zPMJqLbnCYlKQz1LxlKBc
         AE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=R1XJTYwA9rZTm20kUJO47vIgsaq5Ujs8OtaAarvQRMU=;
        b=3sGYbk7CTsxN1EN+lHQx/sBpE3g4odzzOwd3hZgASq9MVk4WLtmn00//SuZ22Q5sGz
         pClMxy9XuGCYgZjvOPvJL4YBSi0LFc7xj971MaZvWTYWlVqXXXtQOkfp35uwg8Sk/fww
         jhf2ZLILP4g4TdfQ53oBKWYOjfiDXW3074NsIhQqFPwwAb4qaHCtedpgz2H2/wc9Px0O
         TU/0OYIoMc3f/Jh7tCDUw077sqbbnea70s6wVSP3uwDRLtwZMOKBel+cuZAG4fvh8Fr6
         VPoqD1Pah3Z51MYgTr5muQRZhWIMRsfutdSPLsp5NldQwkLAFwb4xz6fQvzaJ5FesfaE
         KBSw==
X-Gm-Message-State: ACrzQf1c3XzKNlJhpUmtDEMnDNUD7Hzsud+9w1TACzGT4tTYvLrTi+gt
        WlYBQspzdS+4nq8UGp2iW4YoOX+yAJ6So9AaBgC75EuQFkFaSA==
X-Google-Smtp-Source: AMsMyM4apNcjnLIkgola8fzAxSa6SdTtUlFzoV+R2FbbaYAeV+vy3GPA3qEYnh3SMiywwjvVYRc+Oc+XmGyE8J9hAZQ=
X-Received: by 2002:a05:6512:685:b0:49f:4929:4c6e with SMTP id
 t5-20020a056512068500b0049f49294c6emr3417636lfe.642.1663936503050; Fri, 23
 Sep 2022 05:35:03 -0700 (PDT)
MIME-Version: 1.0
From:   "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date:   Fri, 23 Sep 2022 14:34:52 +0200
Message-ID: <CANh8Qzy4CoXWDD=wpA5HAHWjmCmmin65A+1Y1FEm2BQAs38OWQ@mail.gmail.com>
Subject: Stable / LTS toolchain version requirements
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg & Sasha,

I have a question about the toolchain version requirements policy for
LTS kernels.

I know the mainline kernel documents the requirements in
Documentation/process/changes.rst
but what happens if a patch added to -stable changes the requirements?

I am using 5.4-y and have 3 builds with different gcc versions:
1) 4.7.3
2) 4.9
3) 9.4

[yes, I know 1 and 2 are very old, they are the versions in AOSP 5 and 8...]

All three built fine on 5.4.143 but on upgrading to 5.4.214 build #1 failed.

I traced it to this stable commit

commit 352affc31e269ee6c3ec1c4d2fe65b72b7367df6
Author: Peter Zijlstra <peterz@infradead.org>
Date:   Wed Nov 10 11:01:03 2021 +0100

    bitfield.h: Fix "type of reg too small for mask" test

    [ Upstream commit bff8c3848e071d387d8b0784dc91fa49cd563774 ]

which introduces a use of _Generic which was only added in gcc 4.9 so
that explains the build failure.

However  Documentation/process/changes.rst in 5.4.214 still lists 4.6
as the minimum gcc version.

So, what is the policy on this?

A) -stable patches where the upstream version needs a newer compiler
should be backported
    so as to still work with the original minimum compiler version at the time?
B) Documentation/process/changes.rst should be updated in stable to
reflect any new requirements?
C) Not really defined

Note I'm not complaining or asking anyone to do anything here (and
have already fixed it on my
end by updating the compiler) but I'd just like to understand how this
is supposed to work.

Regards,

Martin
