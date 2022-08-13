Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0440C591BEC
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 18:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239994AbiHMQIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 12:08:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239684AbiHMQIh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 12:08:37 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D529CDEF5
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 09:08:36 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id r17so4978542lfm.11
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 09:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=AM0GRioucOrzWHO4p0HR2p8Wl1Io0HB/IprsOmmvWsk=;
        b=XOYJmO0jZYDBDw0ofMlWKFdCWO0/loJFPQrczai+K3nk8ZZsaeJo6dDdHptdhaD9du
         BRmTQR8FrljeixF6gt9fbOMVt94hzuIcFXr83cBmDBeknRwfw020kLStokHmsRCejHz1
         IoreFkVBvilJ35BmuxqJpGOwu/VPYD/J0wqT7opQwya+aFIp1L5QOtsnLOeEcz4LZ5IU
         JJaNm2bAbSON61mr1Dx65nV8lk8Lo34QKLXKdJZC5R0X/a1r70Iof8NRITFoxFV2lxhI
         +1Fi5nBnBQqRSUhcADvAkMM+Al0Tp6O4VnGB/NmOMSd89dIowVM5AGjix1Ch7VCms1JT
         QIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=AM0GRioucOrzWHO4p0HR2p8Wl1Io0HB/IprsOmmvWsk=;
        b=R8D2mtvN2PgUfi9eJkqw5t4INEjlIJbrT35sdpmaZGBaqBJIG2kVlq7c/ReA0Nbnkr
         /jL1N9I9SmV0oasz0DoMpgMh/hCxRsQ1xchkhYGaUSoHDOMroYAS1BYMSp5T82f4L8JT
         +vOxrrNx2ud+ceQPECU3k7t4E7dmPcQINW0RPn1SocMZ3HQZ/ofusrOwreSM/bB2CxB/
         hc0aYMTZlsHJryxQYPPi5t6CDiafWZ1K8MvOTFV5Eb9ss5HWJbaJ0eRHp8ibJ0QgsAXY
         u9mIrF4JMX8xx5S8utDHmjyHGMCc1Udf5e2UvB1YRg6MbpIKnOewYl4kC8iTbnELIce5
         MNFg==
X-Gm-Message-State: ACgBeo25ByAbc9ivWVJxohyAO69v5IrGyzCIt4hsonhkftFZieWrJUB1
        Pzr1VINMtnWOhLvPsOL6dE3akqvlPwaHk+t9E+c=
X-Google-Smtp-Source: AA6agR53O4LL2sQnH65PtyDVIh+b7r3yqwccJEPpcX5bKQMNf9njUibAacMnvNAKqbbTqTExZ7Dql+9WuCBeia8AwFY=
X-Received: by 2002:a05:6512:304c:b0:48c:ed09:1e95 with SMTP id
 b12-20020a056512304c00b0048ced091e95mr3165693lfb.642.1660406915199; Sat, 13
 Aug 2022 09:08:35 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9a:7a84:0:b0:20e:56d1:75ca with HTTP; Sat, 13 Aug 2022
 09:08:34 -0700 (PDT)
Reply-To: wen305147@gmail.com
From:   Tony Wen <weadmn10@gmail.com>
Date:   Sun, 14 Aug 2022 00:08:34 +0800
Message-ID: <CAJ_OnsjN9iAtcNpb1+q1pzXnA8zQ3wOqufB-0mLK-tnTG2y=1Q@mail.gmail.com>
Subject: work
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:130 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4998]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [weadmn10[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [weadmn10[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [wen305147[at]gmail.com]
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Can you work with me???
