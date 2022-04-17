Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8A350495C
	for <lists+stable@lfdr.de>; Sun, 17 Apr 2022 22:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234925AbiDQUDl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Apr 2022 16:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234937AbiDQUDk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Apr 2022 16:03:40 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B44351170;
        Sun, 17 Apr 2022 13:01:02 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id u15so23752513ejf.11;
        Sun, 17 Apr 2022 13:01:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=eay0EUYLiuox0vdGN4o3I8zJaDIt6G96vlIeYyTE7ck=;
        b=dC6qUspPjw5tWdVPOtykjQ8Wdc9Mst+wRO3PfuDY7u2WB3/qktQe59YVeiw0rQfwOQ
         QIM6BDppKjX2onelnB0ZsAMnVykdPXl/CMciwYgHmlBHBdiZTq3kHqc+0iKRF37TS4L5
         Je3AxPD+EH5AZhGvndCR3InU+YQ2+MoZVKTr3cGmJ8NM3X0jcFRQ0QSm3ROorQhziOw4
         5SzslT2m2N5fjbD7ELJmcOFmO9RQd7c/aIBPCuU9alcAtPYH1wY75srf+g0/LOVo0G4m
         6mmVjowR24CXMoeUddT13+9CO+7MUnCEiCcFtx5X3OOHuXBGBDG+RaQu3C0Ii6DAuVJM
         9Rbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=eay0EUYLiuox0vdGN4o3I8zJaDIt6G96vlIeYyTE7ck=;
        b=0d1IBN+Nu0net71zTreJ9VKd3flMMbMgZE2l8Mc4vhLiFxprecczecn1Pjj3Jmksv0
         8X5oq2pq+nTZrSv+UPO2If2sM6C6sXPmdPXhQ+2Bia3l6rMLyDD5evGavBKUOIckMXsr
         Rmz2a33QBDdkwRaPEH6fU0fi4ketfbLkIzCnv7M1pnSKfMlDp6r/5QP4bY/seS8dQHld
         Pvl1+Mj/2SaMjNYI+qg7zvtXcmXRSv6YJCY9aTN7JtBjzWbLj8NZqbVKsLpVzRmicWMt
         teXDnn+QyDtJhKD5jtFvhAVPgXy0g3f5ymxcop/VQsbRXe04ZRnRfmE/i8C7tIXwzVMq
         X8/Q==
X-Gm-Message-State: AOAM532I9iYUJIm5aD558CL66O+CuL8/2zUvUspwoObsYGFPDCiAQ0M2
        Wjtd2Vbtr/G/9x2kW2YJnHk=
X-Google-Smtp-Source: ABdhPJwnhIUn+CtONHayEHvicQLj0Kbx4xYB5A4yDc6V4LQQPUbxVcWNSKDTvTkh30UA85Eny9zdsw==
X-Received: by 2002:a17:906:e18:b0:6e8:69c2:528c with SMTP id l24-20020a1709060e1800b006e869c2528cmr6442403eji.439.1650225661348;
        Sun, 17 Apr 2022 13:01:01 -0700 (PDT)
Received: from [192.168.144.19] (mob-5-90-199-215.net.vodafone.it. [5.90.199.215])
        by smtp.gmail.com with ESMTPSA id k15-20020aa7c04f000000b004229daeaf37sm4010853edo.40.2022.04.17.13.00.54
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Sun, 17 Apr 2022 13:01:01 -0700 (PDT)
Message-ID: <625c71fd.1c69fb81.68fae.3a73@mx.google.com>
From:   limburgmauro@gmail.com
X-Google-Original-From: rolandohanger@gmail.com
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: GOOD MORNING 
To:     Recipients <rolandohanger@gmail.com>
Date:   Sun, 17 Apr 2022 22:00:53 +0200
Reply-To: richardwahl01011@gmail.com
X-Antivirus: Avast (VPS 220417-10, 17/4/2022), Outbound message
X-Antivirus-Status: Clean
X-Spam-Status: No, score=3.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,REPTO_419_FRAUD_GM_LOOSE,
        SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Good day,
   


I am Mr. Richard Wahl, you have a Donation of  =E2=82=AC1,200,000.00 . I wo=
n a fortune in the Power-ball lottery and i am donating part of it to Ten L=
ucky people and Ten Charity organization. Your email came out victorious so=
 Reply me urgently for more information via email   richardwahl01011@gmail.=
com

Sincerely,
Mr. Richard Wahl
=2E..............................................................

Ich bin Herr Richard Wahl, Sie haben eine Spende in H=C3=B6he von 1.200.000=
,00 =E2=82=AC. Ich habe ein Verm=C3=B6gen in der Power-Ball-Lotterie gewonn=
en und spende einen Teil davon an Ten Lucky People und die Ten Charity-Orga=
nisation. Ihre E-Mail war erfolgreich, also antworten Sie mir dringend f=C3=
=BCr weitere Informationen per E-Mail richardwahl01011@gmail.com

Aufrichtig,
Herr Richard Wahl

-- 
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus

