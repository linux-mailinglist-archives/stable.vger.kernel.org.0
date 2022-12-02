Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C17836406EF
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:38:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbiLBMi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:38:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232372AbiLBMiZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:38:25 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCFD4219C
        for <stable@vger.kernel.org>; Fri,  2 Dec 2022 04:38:24 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id d14so1356385edj.11
        for <stable@vger.kernel.org>; Fri, 02 Dec 2022 04:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3F5VNxfTKyX6PR+sW41djwfBxWIbg3en8d5fF7dJfIk=;
        b=BbRBhkPIm6BQ6kVPUe72mVBUeMEIhmormTPj2WmVPPDyRp2m+dE83pmjoCS4a0JDhK
         RFTCi5h14l9VqvC6eQqb11HWY6ncNGd9T0qcZp6fIbz2rUyhzmtpalF85+/z6fTd7Lj1
         RvCbdLbfkHsSTWWIu9oGa0ZXnoAZuui/Op1imCTFvaZ0KI8/WgPHYDIgFjLtoJfnC0XQ
         722upSEK5xCuiBfmfNi+AOGaDG2MsnlnOR3+0vKTEGU2nuZmYuOtI+4zpwyW6igtepC/
         +iEk9UJbVEc7OmSUb2t3JXH8CLyUleSDzINhf8GIM84F5e2CWRm44ccGc6P++htDiIaV
         eN8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3F5VNxfTKyX6PR+sW41djwfBxWIbg3en8d5fF7dJfIk=;
        b=rCsThBnC6K/wYaLrJAV5Vm2krukHA92wOntAb16jqaoCpXxzMRhCrq4I2SS6m30TuC
         WZ/jna0Yj+ZHSmbfSwFqEQuNpvg16lQd/I9yHB1FhyA+pDGAd7umm+5OKKuif3WqIAqi
         H0GwnR9SElpHU/YGVwJlA7BCgiENsTFnMLsxJDO5miKhZNgJ5DhtGUIyxSmxOUEDJVRS
         KVWLdvvIQuiTi+aK+ECS4ZCo67UfAYeuJ7nef/x4tpq4GhnrC6+49NgOSaxup4NvNdCP
         rukXE9FM1vDiUF5mfBjtN7o0PsdZ7KejyeT5UzVEgoeTTru2xMRJ8E134ltarNxv5S/E
         8FCw==
X-Gm-Message-State: ANoB5pnj3kLa+clI3ZowFNY7yuO5OKvp6J9Ly5VS/DMuAENtnXxPQ+oq
        xegKrz/eEZIcjToNBfntsm1sRTpYUntv9j3WdFY=
X-Google-Smtp-Source: AA0mqf4D7jUjxIfEEHnAxiZra44Bfhkl9VPeSTvOReHz8WiE/e0ePls7GJ7SBtM8ouHuYpOfzrZt/mFCu4YkFwnH44I=
X-Received: by 2002:a05:6402:4499:b0:46c:43fd:d1ab with SMTP id
 er25-20020a056402449900b0046c43fdd1abmr1040855edb.197.1669984703195; Fri, 02
 Dec 2022 04:38:23 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a50:3741:0:b0:1ea:cbec:d093 with HTTP; Fri, 2 Dec 2022
 04:38:22 -0800 (PST)
Reply-To: keenjr54@gmail.com
From:   "keen J. Richardson" <laurajrichardson242@gmail.com>
Date:   Fri, 2 Dec 2022 12:38:22 +0000
Message-ID: <CAA2Q84+EtxjUUGz3Dm7VJhSzHrC6ncCzRiBc+FaT9LoLmYx8_A@mail.gmail.com>
Subject: =?UTF-8?B?2KfZhNiz2YTYp9mFINi52YTZitmD2YU=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQrYqtmFINil2LHYs9in2YQg2KjYsdmK2K8g2KXZhNmK2YMg2YHZiiDZiNmC2Kog2YXYpyDY
p9mE2KPYs9io2YjYuSDYp9mE2YXYp9i22Yog2YXYuSDYqtmI2YLYuQ0K2KrZhNmC2Yog2KjYsdmK
2K8g2LnZiNiv2Kkg2YXZhtmDINmI2YTZg9mGINmE2K/Zh9i02KrZiiDZhNmFINiq2YPZhNmBINmG
2YHYs9mDINi52YbYp9ihINin2YTYsdivLg0K2YrYsdis2Ykg2KfZhNix2K8g2YTZhdiy2YrYryDZ
hdmGINin2YTYpdmK2LbYp9it2KfYqi4NCg0K2YXYuSDYp9mE2KfYrdiq2LHYp9mFINmE2YPYjA0K
2YPZitmGINis2Yog2LHZitiq2LTYp9ix2K/Ys9mI2YYuDQo=
