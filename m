Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE9C6E124B
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 18:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229522AbjDMQat (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Apr 2023 12:30:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbjDMQas (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Apr 2023 12:30:48 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB90A5C4
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 09:30:46 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id bx15so14133454ljb.7
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 09:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681403445; x=1683995445;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L1j1ItSA6uqXTN6K0z5LsrEohlRdnaW1Q8DiNhOzQts=;
        b=ZFHFehWAbX9SufXZ5yWKbS08pClu1p3n62YprrrEnsD2wzi+OGVPqnz5X5GfO607Ot
         JzJ7BxZO/K6nwvL/cpjzbyPtgD459AgoDlapkrvZHp9cn/YM7XIAYW3yaEZk847YDKyG
         nf82vTBOEn+tMJTPGQEST2zKfKkI6gFUuUEfldgOwvocZfADQLs26uFXsb/gRfnF60Aq
         H37a2xw67wcdubmBxkanLwJuM8kUKVVI70pYb4WackPR+8LFIPEvcp0cNRIoSJDafQJP
         glqrkyaGv/zoJlFNE8BYMEO6YI/6SHz1LGl4sKgCS9exfIA4AArIv9bml9XDyOpL5q5K
         1i/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681403445; x=1683995445;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L1j1ItSA6uqXTN6K0z5LsrEohlRdnaW1Q8DiNhOzQts=;
        b=NBOEa7S3RT+HT1URTAyE1/PvkzAeUuKoYDUT2zzrsFtGGxUxs4D+lQ6ncJq0KgWoD7
         I4sbWZGtaEoZRXfONiQgSTyou/5xTlETREeAJcZjbUpqZlJb37CvYXQKR80iXHLskFmr
         Q/Cee1KOVZfVmbx4GujItzID54iDh87r2C7XRYgHZ88JM5dJGS91Kq6aXkeOEqEr6cfO
         /2wg/+cwhticbUroD+2JkmZVj/WI/4H44xcTpYEkhNk+kvL/kC2FLzP9zG9SAzLS5wEJ
         Eoic/QIdmoY695LobgsOFE4NyfL8rZIudWgYlfvo0C2H25mMcyCLSCMSj+Z7fRD5XF+r
         uVCQ==
X-Gm-Message-State: AAQBX9fhrN5D5f5DFWbog4wRF2ZK2uE09ekUyE2yMqvFx6MWn8uvR5pQ
        LzgIQ1UE/obFceyE2RuXNltfaxN8F1SLIvrV9O0=
X-Google-Smtp-Source: AKy350Zt/aAoQQ3gctm37Qbijq7tHsF0plvON4m47oiurbHnwApeQ1fUegaeyDI0M6i9ZFgTR6QwvrFef1fHu3ZyVhw=
X-Received: by 2002:a2e:9dd9:0:b0:2a7:9952:b244 with SMTP id
 x25-20020a2e9dd9000000b002a79952b244mr938628ljj.9.1681403444874; Thu, 13 Apr
 2023 09:30:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:7017:0:b0:2a7:779f:4c2b with HTTP; Thu, 13 Apr 2023
 09:30:44 -0700 (PDT)
Reply-To: mr.luisfernando5050@gmail.com
From:   "Mr. Luis Fernando" <mrahmedmo04@gmail.com>
Date:   Thu, 13 Apr 2023 18:30:44 +0200
Message-ID: <CAC+b6+XLN1pFjYuK0xWf++FQCBCsZznD=ZRDrQx6-WweRM9ztg@mail.gmail.com>
Subject: Good day
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.0 required=5.0 tests=ADVANCE_FEE_3_NEW_MONEY,
        BAYES_00,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        T_MONEY_PERCENT,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:244 listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mr.luisfernando5050[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [mrahmedmo04[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [mrahmedmo04[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  0.0 T_HK_NAME_FM_MR_MRS No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.5 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  0.0 T_MONEY_PERCENT X% of a lot of money for you
        *  3.1 UNDISC_MONEY Undisclosed recipients + money/fraud signs
        *  0.0 ADVANCE_FEE_3_NEW_MONEY Advance Fee fraud and lots of money
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

LS0gDQotLSANCkkgYW0gTXIuIEx1aXMgRmVybmFuZG/igJkNCg0KSGkgRnJpZW5kIEkgYW0gYSBi
YW5rIGRpcmVjdG9yIG9mIHRoZSBVQkEgQmFuayBQbGMgYmYgLkkgd2FudCB0bw0KdHJhbnNmZXIg
YW4gYWJhbmRvbmVkIHN1bSBvZiAyNy41IG1pbGxpb25zIFVTRCAgdG8geW91IHRocm91Z2ggQVRN
DQpWSVNBIENBUkQgLjUwJSB3aWxsIGJlIGZvciB5b3UuIE5vIHJpc2sgaW52b2x2ZWQuIENvbnRh
Y3QgbWUgZm9yIG1vcmUNCmRldGFpbHMuIEtpbmRseSByZXBseSBtZSBiYWNrIHRvIG15IGFsdGVy
bmF0aXZlIGVtYWlsDQphZGRyZXNzKG1yLmx1aXNmZXJuYW5kbzUwNTBAZ21haWwuY29tKSBNci4g
THVpcyBGZXJuYW5kbw0KDQoNCg0KDQoNCuyggOuKlCDro6jsnbTsiqQg7Y6Y66W064Kc64+EIOyU
qOyeheuLiOuLpCcNCg0K7JWI64WV7ZWY7IS47JqUIOy5nOq1rCDsoIDripQgVUJBIEJhbmsgUGxj
IGJm7J2YIOydgO2WiSDsnbTsgqzsnoXri4jri6QuIEFUTSBWSVNBIENBUkTrpbwg7Ya17ZW0IDIs
NzUw66eMIOuLrOufrOydmA0K67KE66Ck7KeEIOq4iOyVoeydhCDqt4DtlZjsl5Dqsowg7J207LK0
7ZWY6rOgIOyLtuyKteuLiOuLpC4gNTAl6rCAIOq3gO2VmOulvCDsnITtlZwg6rKD7J6F64uI64uk
LiDqtIDroKjrkJwg7JyE7ZeY7J20IOyXhuyKteuLiOuLpC4g7J6Q7IS47ZWcIOuCtOyaqeydgCDs
oIDsl5DqsowNCuyXsOudve2VmOyLreyLnOyYpC4g64yA7LK0IOydtOuplOydvCDso7zshowobXIu
bHVpc2Zlcm5hbmRvNTA1MEBnbWFpbC5jb20p66GcIO2ajOyLoO2VtCDso7zsi5zquLAg67CU656N
64uI64ukLiBNci4NCkx1aXMgRmVybmFuZG8NCg==
