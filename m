Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2827A469593
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 13:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243040AbhLFMYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 07:24:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242984AbhLFMYD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 07:24:03 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BA3C061746
        for <stable@vger.kernel.org>; Mon,  6 Dec 2021 04:20:35 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so42490627edd.3
        for <stable@vger.kernel.org>; Mon, 06 Dec 2021 04:20:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:mime-version:content-transfer-encoding
         :content-description:subject:to:from:date:reply-to;
        bh=4x3yYewioDfUyhp3pdDZTIbSGJZ6hoSyljY2Sda6hAQ=;
        b=UeTR5XgxAlj1n++m6LNk8S7QSziJ/pHRxMzgU6rMryEDUJjCkLJurJfM1obx3f3yUH
         fVFW87Xwao1mvcX/mKeqTowhUGK0BoJywV5O+GkDYB3X5R37XjRiFq6ubWAoWIbMVMXe
         VgGKFUgmSsk7CHXQbR6Uw7EV00I6ZVjp2i9Avy32np1wAWTAMkoPJmJcyRu+7WFofeQ6
         59wjLON2egcshwzZRkAHq356BGYbImkkKv5kOAoSodogVFZl5tUOmYrJWACxaubbIshy
         F3JYygRs/W1rUhj15n4coaOWDa6evA86So0HAEpROe1Gqb744sCnmyd8Rd4exPATTPVN
         +ZyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:mime-version
         :content-transfer-encoding:content-description:subject:to:from:date
         :reply-to;
        bh=4x3yYewioDfUyhp3pdDZTIbSGJZ6hoSyljY2Sda6hAQ=;
        b=YD/8+osZiWyLJBUneI0VnC28tZQYrxfWKwYk4MUBJEBFuvyuLAaW6SA+AcS4YvgEhA
         LQk+5RKcljHDynOLrb/5oo10xiQhMpaD7k01UTpYT3KA4oGG86yN8MwpN+lCXDrdDVGT
         ExTSKDOK9YZLkrl/sTkFHrNIv1GYnEF8RkWLlaTjaWw4XZ3f2Bp3nvoVPQBRY+EBE6ZN
         ggFGvPC530UyOpfPWJFkoYXvNKHXkRySLA8q4S4LIxSG+0IGIfZ4WM5bvtKvsh2d/9fg
         FjeAvgCAu3KlDW4Jv+pRYiDNg7HtMKNVDIQzW3k3qkebkZ9H/U2f84aMnVD42tCmmhlh
         D8/g==
X-Gm-Message-State: AOAM533Mf87k6yhbtw4Prw0XUIgZhRLWOMmO/d1LbTtRLWeaNAOIqQG3
        d7VETDWq74kywd05EzQwpDH0LoFz3kDrUROJ
X-Google-Smtp-Source: ABdhPJwvfzWXSMRfQbh4B17hH4vSCebgDMB9yVevsa2gqEQXq0Za0L3HaSL73mD82Ug7CbbhURnZ9A==
X-Received: by 2002:a17:906:dc94:: with SMTP id cs20mr44820184ejc.117.1638793233851;
        Mon, 06 Dec 2021 04:20:33 -0800 (PST)
Received: from [192.168.43.235] ([129.205.112.57])
        by smtp.gmail.com with ESMTPSA id nc29sm6701080ejc.3.2021.12.06.04.20.26
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Mon, 06 Dec 2021 04:20:33 -0800 (PST)
Message-ID: <61ae0011.1c69fb81.af1c9.5ab7@mx.google.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: =?utf-8?q?Ihnen_und_einigen_anderen_zuf=C3=A4lligen_Personen_1=2E000=2E00?=
 =?utf-8?q?0_Euro_zu_spenden=2E_Kontaktieren_Sie_mich_f=C3=BCr_weitere_Inf?=
 =?utf-8?q?ormationen=2E?=
To:     Recipients <okoriechikabest@gmail.com>
From:   okoriechikabest@gmail.com
Date:   Mon, 06 Dec 2021 04:20:08 -0800
Reply-To: elimsmaria43@gmail.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

aIch bin Maria Elisabeth Schaeffler, eine deutsche Unternehmerin, Investori=
n und Gesch=E4ftsf=FChrerin der Schaeffler Gruppe. Ich bin einer der Eigent=
=FCmer der Schaeffler Gruppe. Ich habe 25 Prozent meines pers=F6nlichen Ver=
m=F6gens f=FCr wohlt=E4tige Zwecke verschenkt. Und ich habe auch zugestimmt=
, die restlichen 25% in diesem Jahr 2021 an Einzelpersonen zu geben. Aufgru=
nd des Ausbruchs des Corona-Virus in Europa und dem Rest der Welt habe ich =
mich entschlossen, Ihnen und einigen anderen zuf=E4lligen Personen 1.000.00=
0 Euro zu spenden. Kontaktieren Sie mich f=FCr weitere Informationen.

  Kontaktieren Sie uns einfach unter: elimsmaria43@gmail.com

  Mehr =FCber mich erfahren Sie auch unter folgendem Link: //de.wikipedia.o=
rg/wiki/Maria-Elisabeth_Schaeffler=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D Mit freundlichen Gr=FC=DFen Frau Ma=
ria-Elisabeth Schaeffler, Gesch=E4ftsf=FChrerin der Schaeffler Gruppe
