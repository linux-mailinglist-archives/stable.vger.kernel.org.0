Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCD735522BC
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 19:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242587AbiFTR2R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 13:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242638AbiFTR2D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 13:28:03 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFE3FF72
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 10:27:55 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id t25so18328179lfg.7
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 10:27:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=D4JiK7qPcxlbdJHG4Ttqf8GtWMwLHVdSApaFwkOOc5SVjdU093zJIIWjqmVUs9LFC3
         h0ZoQeACXr6vd23CDbj3o7mKZNczIX/YMSU9OErMgXnSJ71iqbbhIdkSQ9OQSB1uX0ft
         ZMi43JofDfshidmZPJ7Ucc3vatADgLqbfmMnq3MaPa4n2IqD0O7Z7adlW/9AXwA+S5Xe
         3xbe33YE3m8vN/DaPpUgNBO63oAo8Skp0Oz4NqTrEvW3UN9q2h9WwYSuZYV34Mzd5Bm9
         2I1yUD/8hicUD9layFf/cH034IvZH8ERgwyPrmwCMt+jM+/98Ii/IY9S3Jjc5KD77WA/
         6FlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=8Hq/OMxti4rqkdWeHbWObNF2QDGVJSUh5u3SgEpoLS1GT1L6OaSlAh4zEV8gY7UvIx
         iUpbkPuUjlqKm+xYb77E483gzHEq9TPcol0bLdLLbjXkpQgpI9e97cTGTjBPv+lWwO7z
         jZ5HL/4NRGa3xd1dOmlpFQrEKyXPmFVOdTrGU+IIcOqhAYQIxUj/3YukZXUx7B7M9rRz
         lUSrewTA4loGi+E4Ec5IcChKYe+OD28sCt4zagwDg1lWyr5gqZLVDBOiy/gxD1+ecUBR
         rxMUEWxrUQGwlyop9NgLgxk4eQF0uDCnYhL4n1phL+vber5lsiBi1tAieCbU3Y0j2OW7
         nkKw==
X-Gm-Message-State: AJIora8lG+5MnIzAwtLTzGXLKV1BlrgdQgTqamP0My6wtjuWPIhrMSAM
        jVMm5CLH7S0+vIqw8LBPHGQbPQBb53VILrY4TZGSz5Hzn3PrCw==
X-Google-Smtp-Source: AGRyM1vysdVkPYSHFxJCKm0gPWc7tSs9DgIxhENc6EPNYUesyGejmxUBHBmBeS+m0mVRkwxW3WOSK/aIAJRI7w6sIAs=
X-Received: by 2002:ac2:4903:0:b0:47f:66c2:170c with SMTP id
 n3-20020ac24903000000b0047f66c2170cmr5312824lfi.524.1655746073939; Mon, 20
 Jun 2022 10:27:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220620124729.509745706@linuxfoundation.org>
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Mon, 20 Jun 2022 22:57:42 +0530
Message-ID: <CAHokDBnEWa6tK7E0S6GTuy7Km7gU3PEkHspnWSWGAUB=hcQMKA@mail.gmail.com>
Subject: Re: [PATCH 5.18 000/141] 5.18.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
