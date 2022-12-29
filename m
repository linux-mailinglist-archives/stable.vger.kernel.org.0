Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89956658962
	for <lists+stable@lfdr.de>; Thu, 29 Dec 2022 05:23:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbiL2EXU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 23:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiL2EXN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 23:23:13 -0500
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6ED412757
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 20:23:12 -0800 (PST)
Received: by mail-io1-xd42.google.com with SMTP id r72so9269947iod.5
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 20:23:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=reply-to:date:to:subject:content-description
         :content-transfer-encoding:mime-version:from:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jmvDLwpHkH8FaVzu/Ma7h71eJBYmgoQrtEyy6Z1Be8I=;
        b=A8W9LrCdjeSw7C17gp2c/N2ftOmst+dm8guwB3/IlmFiCfkewvzIspoLHjGfJlRV5f
         iwz5zfbfbtQlm88hxtv/TTaNqsHQAF369MWCU2JSkch+TBjtOB7r8Li8KxZOPI4ratWO
         OjmTCjt93zMI0F2r4btzHNdo4GhoM277mV1aiHIz7y50yiEaWTb8GBQVE3iPY+p4g5Bc
         IrUcDLvkWaCfr230TXdjlG3dYH5eFtsrJgp0tW3CCaF4s4/pES1GYBY05BDKZTAxhJn2
         UVi6quEjtN82+xpmykJOOSxPgRABtag8KzmcANKMG4UrWgQ0AM6OOkM2xCZe3TLuLh+x
         O7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=reply-to:date:to:subject:content-description
         :content-transfer-encoding:mime-version:from:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jmvDLwpHkH8FaVzu/Ma7h71eJBYmgoQrtEyy6Z1Be8I=;
        b=jNFv58ZmIH4BWFffLmhFwdU/GxPrrcvx/Z75yywbEDQCFrjXZN60ca4efI2vdCyEnK
         YQHfODH9AxWY6G23do7azjV9UTX6+jdHe2BXzsgwEP/VhoHkJ2fGNHDilZqykAF+yXpc
         fv0CkLhM4dcpqeX8MtOxYdfvt9U/tDOcsOOlPotAV79uG6tem+LQ2bzE/tr3IF8o+Sx+
         9TDOmKhVqYaqx6oXZ1QxCwQ3W/W8pWKHBgnluFl1j8q0KqwNtekHhbuuvtGl/5kY0f4P
         SL1OHMr1TSE2pcGgbdXGdDY2Qh5zJ6LrFpf2ETeswuHgfstFTVTgUh1gCTdhCQ51Fgnk
         3qQA==
X-Gm-Message-State: AFqh2kr/aywEBUBBXgH74b4HoCETtN0mlO8K0ylNDWYfPR7+nza7uaAl
        iSRdnLGNM5wkKIeBb6aR6II=
X-Google-Smtp-Source: AMrXdXvs9t/7nO/DS1PVYExIImxlQu7MBC8+GJUTlqJFQ0n/X5HUfPc/HNcZW6jPoFD96lT0QBTdHw==
X-Received: by 2002:a05:6602:2a47:b0:6df:3e46:ab2b with SMTP id k7-20020a0566022a4700b006df3e46ab2bmr29257622iov.6.1672287792011;
        Wed, 28 Dec 2022 20:23:12 -0800 (PST)
Received: from [0.0.0.96] ([96.9.208.18])
        by smtp.googlemail.com with ESMTPSA id y23-20020a027317000000b00349c45fd3a8sm5642304jab.29.2022.12.28.20.23.09
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Wed, 28 Dec 2022 20:23:11 -0800 (PST)
Message-ID: <63ad162f.020a0220.98ed5.6b79@mx.google.com>
From:   Sopath Heang <vishalkumarmx@gmail.com>
X-Google-Original-From: "Sopath Heang" <unknown@unknown.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: From Heang S
To:     Recipients <unknown@unknown.com>
Date:   Thu, 29 Dec 2022 05:23:08 +0100
Reply-To: sopaheg@gmail.com
X-Spam-Status: Yes, score=7.7 required=5.0 tests=ADVANCE_FEE_3_NEW_MONEY,
        BAYES_50,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:d42 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [vishalkumarmx[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  2.0 HK_SCAM No description available.
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.4 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  2.7 ADVANCE_FEE_3_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

My name is Sopath Heang,a season banker here in Asia.I am account officer t=
o a deceased customer of our bank who bears the same name as yours. He died=
 many years ago with his family without a WILL. His account with us $35.5 M=
ILLION has been unclaimed due to unavailability of next of kin/relatives to=
 claim his estate.

In accordance with the escheat laws in Cambodia as a kingdom, the Board of =
Directors of the bank met forth night ago and resolved to turn the estate o=
f the deceased over to Government pause having waited for too long without =
the deceased relatives/next of kin surfacing property and if this is done, =
invariably, the funds will end up to become Government property and it is a=
s a result of this that am moved to contact you considering the fact that y=
ou share almost the same name with the deceased.

In view of this, am seeking your cooperation and understanding to stand as =
the deceased next of kin to enable us claim the inheritance before the peri=
od given by the bank elapse. If you are interested and in agreement with me=
, get back to me quickly and I will send to you all our bank contacts and t=
he informations you may need to proceed without coming to Cambodia, and be =
rest assured that it is risk free deal and the proceedings will be shared 5=
0% me -50% you once the fund are expatriated into your account anywhere in =
the world.

I await your prompt response immediately.

Best Regards.
Mr.Sopath Heang.
