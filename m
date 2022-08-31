Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F26A5A809D
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 16:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiHaOuJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 10:50:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiHaOuD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 10:50:03 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E5FDDFB1
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 07:50:00 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id f12so14169984plb.11
        for <stable@vger.kernel.org>; Wed, 31 Aug 2022 07:49:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=51RIadb6uMG8qQNL2W77cS297AVcIqUghNiTlwSKJng=;
        b=EL8/7Dr+ebFPBpJTC5Z8pbTewKp9Soe6ZWYoEJg9ptSfVxVFU1At9+u6Y5UL2bjGbU
         eBnRSykOnZ0xcPs+COLbcwi2gm9nk0h6Q/Ja6FilYhpkMyLMMNENPU4Ooe88rY1mqfo3
         6XBatI4MNVespzPM6VJeCwrZxv36ZVhkSr6yFcBw8k8Ko0Qu2nHRhcbtraZ4n+W89E3d
         4oUoohn5WYDHk1R1GBb5pX/ycbtNu9v7ABEknZAqQqrYCCjkljqu9wi8YOtObgMntOB6
         QxphPz8CTCSIwEXJmt+k9HKJfg/jXdDRzA8A+/wsslNyQd7DPk8TtncrTXxRKvppi5kJ
         v25w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=51RIadb6uMG8qQNL2W77cS297AVcIqUghNiTlwSKJng=;
        b=rY2k3TvIGJ6pqw+zHr0cA49pkr4uL+OqfxSGoEMOG1Gg+dcVkEkkHJUBq36oTlXo+L
         GmHXAsxMxUyl3AwTxUErpOj9532+bic0E+PiaglXVKBVGUtfREFDgeyYK36lLUj7EqIN
         XolKq8A5gqX4g7J7ompCapHg21uqap8qoZq07J2Rk7v3y2aIpBG0/dFd7ZigrUFSt7ov
         ivAcr61JumZeIL+hdFU2iCitelPOk1il/QmywEKodD/gRT3/ElmNkZw0fBX5K9OpPVVG
         o/67Qn96ZfzDCPLG2H41/G+gMAbzlJT/5NEOMfgRutJRWfe4bi9PgIwqnbo594GcDJoB
         CS0Q==
X-Gm-Message-State: ACgBeo0zoB034JsAPwvR9NDoGXxRioVCFDgkF6bEonpflmzKidBNUP6O
        TTZkAL4A4uH/HcNSGXeRZeQbt50ANqAE3/winjM=
X-Google-Smtp-Source: AA6agR6OeDid1OZpY7CmQNmpk+ghGG66ptoGOnQLpRGb+WdgAiWlwyYU6qvmuRBVDYmKVe09nywtT1qrCljv8w7Nzic=
X-Received: by 2002:a17:902:8498:b0:172:a201:5c12 with SMTP id
 c24-20020a170902849800b00172a2015c12mr26066550plo.166.1661957399414; Wed, 31
 Aug 2022 07:49:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7301:378e:b0:75:c9b0:dc11 with HTTP; Wed, 31 Aug 2022
 07:49:58 -0700 (PDT)
Reply-To: nelsonbile98@gmail.com
From:   Nelson Bile <bilenelson4@gmail.com>
Date:   Wed, 31 Aug 2022 16:49:58 +0200
Message-ID: <CAOmdxP_93bWYNv+sK=KuXHofPZbqU8RCL1MmU2c1VjJYrcwg5w@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:62a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5014]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [nelsonbile98[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [bilenelson4[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [bilenelson4[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hallo, ich habe dir vor ein paar Tagen eine E-Mail geschickt. Hast du
meine Nachricht erhalten? bitte um dringende antwort
