Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0950462499A
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 19:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiKJSip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 13:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiKJSio (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 13:38:44 -0500
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B04C462F0
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 10:38:43 -0800 (PST)
Received: by mail-qk1-x734.google.com with SMTP id k4so1665988qkj.8
        for <stable@vger.kernel.org>; Thu, 10 Nov 2022 10:38:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vnxQjZW8lEQBD88xLIPudVLr0XdcrViwtVRcw9aWecA=;
        b=hLzYddv2v9BK8p85ShrXlafvOL2NRhlx56SE2LTZfvbQiZKJcY2VOiFLOB//frVO2K
         VcHYY3qQFz9xojmsXMk4HtNf+75EcxDGIo2YEcPwwcxOPzze6Dze+EIgBNOk7amMiPL2
         pUL1LTyvu8jSSfhPqgoBTiCW3jELKUkB+MB4BHAhnNRr3vt3STf3uapDJrEdICOGsc++
         NeCK/OyoCAWBIjxN0q5AiG267TjM/mok08WqGtUpJFb/oeyhY9tZBITsSgz1bfU5lqaZ
         EkIEO8pX16GWz7uXrNRPvI0NRA5zd3nUbWodIAovrzDmQWC/MSdPpBJUsRdq+/sRISxz
         udUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vnxQjZW8lEQBD88xLIPudVLr0XdcrViwtVRcw9aWecA=;
        b=DupvE0CE8V/jYI6UUu4NffSlPYDJlnwuIIo3D0+y/zX0z/n9s/QguoVJk5vyR0iVA7
         Vifh85cuSmokvYfpKMtFHMeQlg2euBk07REFWf6CCKTPxo/+aUPy0KrsESDKQUBSCFAW
         FBLuHk/ZCIaIPnOYUaO5+bZuIJ1BERl7E1022pgrBE0FaXfxfXMdLCaNaASfPggvz5kP
         2EqeTIIGDEJS9NNnIyNWV2PaZEUfd81G6DfOJJwOlViiU/kXQT6x4AvGjBBPLqqCdsfi
         pZt190jRlHnbyLueFhU4ZQ5vU86FAyawtHTl3YRWD2q80jG04MgT8edmk0OUpUneeM1o
         FtEQ==
X-Gm-Message-State: ACrzQf3kS79J76jRWiJcjWXeaIRAUrlupEYuNkKiJRngIenUpKT6Z/Xv
        ESC/pb5fYNYzCIl0nIB72ghpkWgZgOfbIMsONHU=
X-Google-Smtp-Source: AMsMyM6jlT5L7w30hED0s4EgoHAzq2SA0Bx+YUP8PKB2m4GeOHdpBtlgy963nH1yhHdvXrq1FHyUaG2GfpUfUoJ+siM=
X-Received: by 2002:a05:620a:490a:b0:6fa:25d4:8034 with SMTP id
 ed10-20020a05620a490a00b006fa25d48034mr1578300qkb.197.1668105522834; Thu, 10
 Nov 2022 10:38:42 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6200:5807:b0:49f:4177:be7a with HTTP; Thu, 10 Nov 2022
 10:38:42 -0800 (PST)
Reply-To: wijh555@gmail.com
From:   "Prof. Do-Young Byun" <dmitrybogdanv07@gmail.com>
Date:   Thu, 10 Nov 2022 10:38:42 -0800
Message-ID: <CAPi14y+bseUgy1zKMyFUWf+dLZmJO+FcsL9_EqfiOjFkwMmDzg@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:734 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wijh555[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dmitrybogdanv07[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dmitrybogdanv07[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
Hello,
We are privileged and delighted to reach you via email" And we are
urgently waiting to hear from you. and again your number is not
connecting.

Best regards,
Prof. Do-Young Byun
