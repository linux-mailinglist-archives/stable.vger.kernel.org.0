Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9058254A9D6
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 08:54:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352657AbiFNGxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 02:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352616AbiFNGxr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 02:53:47 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678673A190
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:53:46 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id o73so5736898qke.7
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 23:53:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Cv5HcBmHzCJq07hlXNxf2As09tP1LpJZtz7OQ8cOZmc=;
        b=pkGLjDcd3HGCKEdkSqh4NMrpH4Rd2gjZJINPpJbetNqgciXsIi7AyX3mftdlmvuWVU
         lbbUlRMw/2VT/KLMry4d0glmAcMNVm5pRxAaIhBZWz64u0fQoI+qB34Ev0Cpj6sfPmwu
         pRsOgjdo1/5JpEuds6Ixl8tinRsNDoH8dkhnhKlCdPRQvUuFfpXPe2vnL8Dthl6b1GC3
         ZnrQJiD/FxdRy1zliWPmDHl1jENLn9JnI2fpClqvuvAFMQUFs6pjQAhl3Urh1KsCLVjY
         /g8CQuHTt1+KlQNHf1N4XhJ8/0hzD5Is3IiLHPgODTlT0j/hO+rKRg3PsOZG2shEcb0U
         uHig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Cv5HcBmHzCJq07hlXNxf2As09tP1LpJZtz7OQ8cOZmc=;
        b=Of3a6IKAOjdkKKDfmfLTeGZWLIH3KdH2pmXRUm63BDvT2RLMGgEr0ThxzuTYZS1Ib7
         sywPY96B+hsWxX/J2Nq4ADXyyBpCl5H+nQNmjTxs2FRI4+3pd7w8p4+fWkZafx1ETsdd
         +E2xxSe4++829znsxEUgph5uOLOayupgpfh7gVpGR9Htnd3uXjngh7dtk1j5FA19yYFV
         uqhZh/NPC8O/mwrvoMy/rOseEvPGSNz86L15xaADKX9W5VdR3CQxgwQ3k5F10kDXFcGl
         KyZ0QRRlo5GOgijHQ14lqw/7ItxqLPa/I2b2Eh7WEQYdkhMwu+J3QqetCT9pLle2Qxwb
         1MEA==
X-Gm-Message-State: AOAM532cPzSgstyJRZQJ6dkrz7gedwMJF+z+G7cAILChCXNWcqg9PnkZ
        PzLXMA5gDXP3UIo9Y/V1ccCvBCqJn/vaN5p+Wws=
X-Google-Smtp-Source: ABdhPJyWN4ST/TVZLWsXad6YI6YdmDQqc8xdctS00UDXKP4ZsNsBnOKa+ZCjyR7CSU2YQXfPDjeXFPdPrw9CqGeLLgA=
X-Received: by 2002:a37:9a06:0:b0:6a6:839f:c34d with SMTP id
 c6-20020a379a06000000b006a6839fc34dmr2834556qke.154.1655189625645; Mon, 13
 Jun 2022 23:53:45 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:622a:199c:0:0:0:0 with HTTP; Mon, 13 Jun 2022 23:53:45
 -0700 (PDT)
Reply-To: quonticbnk22@msgden.net
From:   =?UTF-8?Q?Mr=2E_Ant=C3=B3nio_Guterres_?= <infooou@gmail.com>
Date:   Tue, 14 Jun 2022 07:53:45 +0100
Message-ID: <CAFcwnkzsuXNiMfFzzDo3nu04kVNP9j__Ygdwk4+2NFZcSxLU1A@mail.gmail.com>
Subject: YOUR MESSAGE
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.4 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        MONEY_FORM_SHORT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,T_FILL_THIS_FORM_SHORT,T_HK_NAME_FM_MR_MRS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

-- 
-- 
CONGRATULATION

This is to inform you that your name was among the 18 listed
beneficiaries to benefit from this second batch of overdue Scam
victims compensation payment for the year 2022.

The payment was approved after the meeting held on May 25 with (G20)
and (UN) on World Economic Forum Annual Meeting 2022 and it was sign
that 18 listed beneficiaries will receive US$1,000,000.00 each as
their overdue scam victim compensation payment and your name and
contact email was included as one of the beneficiary, So contact Mr.
Steven Schnall Of Quontic Bank Of New York to receive your approved
compensation payment.

Person to contact: Mr. Steven Schnall (Quontic Bank CEO)
E-mail:  quontiinfo@gmail.com

E-mail:   quonticbnk22@msgden.net

Note instructions have been given to Quontic Bank Of New York to
release your Scam victims compensation Fund US$1,000,000.00 to you VIA
direct transfer or by ATM CARD.

Thanks,
Yours In Service
UN Secretary General
