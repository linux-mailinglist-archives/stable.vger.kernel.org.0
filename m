Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A944D3301
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 17:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234800AbiCIQPW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 11:15:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234812AbiCIQM0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 11:12:26 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95FE14F2A0
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 08:09:47 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id q19so2339994pgm.6
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 08:09:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=CSS8Mh6DSdACbV/mllxQeiyeEUJR18E1XDOW5kord1g=;
        b=SsdQ1VPdsVMqUwKlkF0nZ813zePcgZKZcjQ5GW+K4fQclbxPxOO+aX30vSUZwCrKqo
         AfUlvHFAKTCac5a8Sof1SiWd9zlUyrhum+ezJbDx/JRbloMRby6lZUfOQ2v7U8mHqc3m
         E1c7j5XI3mj3iTprXWpTMkuCddwrYsnRW5E/JCRsyWoL6DSLmh925Pi3Uav6mNmTy5wu
         LhNRvkFZHwRFebsfdjDKj7F9uoQ/nTDVYrX9WohGhXzlzutWcBzYPbWWJYhCGXnTdH+r
         TFw3FYStv4lo6VHPJZtHQSHNix+Yr8t4Cmm51/o7ftwlUSMkRIDS1kkPS7LjSO6unZpO
         erfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=CSS8Mh6DSdACbV/mllxQeiyeEUJR18E1XDOW5kord1g=;
        b=ivSRxgzpKHzexW6JfyOe+KdlFhfcOJ9JT6fZg9N9/ec2cvZJ+nrRwd9r4LjiVDcTn4
         F6GRFGhYNz+e4iq7Hp3shV+ChcvEmOg4SjRT3SXiPviFgDPmUjBCyha6yQ154Ax31YEp
         043Q8htIbj1H7ekwnPX2K0qTFVlNNpknTFK8FOlUCEdXIIN+UFol6v8VTMK7xdTRLF3z
         Up3T0jKKqz+Bxo/bNqdH3xUOiXe9CVWWsoVsafI3MCbx80cwArqXnaRoA0GOGGtMTj5J
         QoMcTg1nhqMq1z+tBANuo30Rfu4obrsSd/7QC91dt0cmpX3L4FbMAVHqDqnecHk4W1ye
         JXSg==
X-Gm-Message-State: AOAM530r57YDpD65cLF043Jklqx8upCaAoGqrqMV+nPyOSAn2t2cdJvk
        KqcZdkM089uQcKmtXJKLf1TqpWk3qIjWkZMDZbg=
X-Google-Smtp-Source: ABdhPJyu8YkHtott9J8DeQDOGQFJOj/I572NPPsA2fEr5tNvZ+Fi4dEUeIMK3q6ZZUDET49vUvP1hEX8kuuy8DOjzo0=
X-Received: by 2002:a05:6a00:1806:b0:4f6:f3e8:b3a0 with SMTP id
 y6-20020a056a00180600b004f6f3e8b3a0mr427902pfa.43.1646842187287; Wed, 09 Mar
 2022 08:09:47 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6a10:6813:0:0:0:0 with HTTP; Wed, 9 Mar 2022 08:09:46
 -0800 (PST)
Reply-To: stephenbord61@yahoo.com
From:   Stephen Bordeaux <jessicawalkert77@gmail.com>
Date:   Wed, 9 Mar 2022 16:09:46 +0000
Message-ID: <CAJeHwU+136nLH-+AxSZEy9iSjU2A5-ddO749gHvVy=wJhPVRoQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: Yes, score=5.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:52c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.4303]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jessicawalkert77[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [stephenbord61[at]yahoo.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jessicawalkert77[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.6 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dobr=C3=BD den  Jsem Stephen Bordeaux, pr=C3=A1vn=C3=AD z=C3=A1stupce z adv=
ok=C3=A1tn=C3=AD
kancel=C3=A1=C5=99e Bordeaux. Kontaktoval jsem v=C3=A1s ohledn=C4=9B poz=C5=
=AFstalosti fondu
zesnul=C3=A9ho Dr. Edwin ve v=C3=BD=C5=A1i 8,5 milionu dolar=C5=AF, kter=C3=
=A9 maj=C3=AD b=C3=BDt
repatriov=C3=A1ny na v=C3=A1=C5=A1 =C3=BA=C4=8Det. Nav=C3=ADc v t=C3=A9to t=
ransakci chci, abyste
odpov=C4=9Bd=C4=9Bli d=C5=AFv=C4=9Brn=C4=9B.  Stephen Bordeaux
