Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 879F25AC5C9
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 19:34:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiIDReJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 13:34:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIDReJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 13:34:09 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A04630F4C
        for <stable@vger.kernel.org>; Sun,  4 Sep 2022 10:34:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id 29so3653412edv.2
        for <stable@vger.kernel.org>; Sun, 04 Sep 2022 10:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date;
        bh=oCmySCCtxBE48Ui6XKBQ0txK+3L6YNxq4OeBEJat9Kc=;
        b=PrpEN6ChMmqKG816IZBtymLVxNWhlD1LK0CoyXzmDPWcFNObWYCxobfIlIhCKZYiA6
         im8cOruSVoH1qHinw0jxZJZ3GfyPlSfC+DnYQtUPMxfmx1aNV9wse7e36n+gsjCTZ5t5
         3pL7u7Rh+APvDKvDfYZu6KlELcRMtXLfYd1ZFhUr8y6uJJYFByMlR0GN+1lxuyULfCF6
         iLNGsiJleK53hIQN+MsQAZ5U2fZsIWcxuVZu35oxs4dtPSQ91i2ck6wBB6MdIRSFQ45Y
         +JYn40UXBfWVtRrL5oXL54bkQY5Gj+rYBDgktoSpCGUzZ1NtjCVuY0f09NmbaZBqceeZ
         3xsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=oCmySCCtxBE48Ui6XKBQ0txK+3L6YNxq4OeBEJat9Kc=;
        b=Yo3AfngkklqKSkSrDyuQEIjUPXMGUgNJClZpZr33hpAKlerS1fyt1Z5RPSdgOEkV54
         s7QdxXQG7r3n3gNAqkAo1xG+qcqWWFQ2Eg7/Y17+VlJE2LcEvCmgbJ7joeTSoJuhROzx
         LHJfCXe4nVcj0mEPbwgAEQX5BeN2rcd5GS4Y8AnIo0/GCsmuqdI6pSId5vzdHj1yFll4
         V0v/1hTno32PcIf/5EZ+8tTPf3cwp8MjOmK3F2497rc+FpZ8ai5in4BGq6QTjr5To+dl
         rChdXTWWncrs8gHWwjmeM4mMZrUkJ6e2QNKDFd2blC1ASkdAj5qkWCZ0mDsDywgv77Ba
         yO2Q==
X-Gm-Message-State: ACgBeo1y4TYFhWnmUzB27BoG3/3hAgOIN/ts/u7WVOhp4lUFSkaB1AW6
        tYSvGrhZwFSHI2+IclCpj2JfRRSgyuBvfdGiCaA=
X-Google-Smtp-Source: AA6agR5bNs33Hkvn8Qi+rIFjxIH0u+F+eNwjLpYVBxU8EOBU+5FXCBzCzg6EKRxmICxqWLo018VrLZyCafMXScbfAdA=
X-Received: by 2002:a05:6402:538b:b0:446:34f:2232 with SMTP id
 ew11-20020a056402538b00b00446034f2232mr38782366edb.4.1662312846961; Sun, 04
 Sep 2022 10:34:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:28c5:0:0:0:0:0 with HTTP; Sun, 4 Sep 2022 10:34:06 -0700 (PDT)
Reply-To: proctorjulius@yahoo.com
From:   Julius Proctor <jeswa7m@gmail.com>
Date:   Sun, 4 Sep 2022 17:34:06 +0000
Message-ID: <CACGCBD5zYeiRtazBS53QNkH3a0bNaqHEiu6rzkgGOhQkzsejdA@mail.gmail.com>
Subject: =?UTF-8?B?UG90xZllYnVqaSB2YcWhaSBvZHBvdsSbxI8sIHByb3PDrW0sIHDFmWlqxI90ZQ==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=3.9 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dobr=C3=BD den

Jsem Julius Proctor, pr=C3=A1vn=C3=AD z=C3=A1stupce z advok=C3=A1tn=C3=AD k=
ancel=C3=A1=C5=99e Proctor.
Kontaktoval jsem v=C3=A1s ohledn=C4=9B pozdn=C3=ADho majetku Dr. Edwin Fond=
 o 8,5
milionu dolar=C5=AF, abyste byli repatriov=C3=A1ni na v=C3=A1=C5=A1 =C3=BA=
=C4=8Det. Krom=C4=9B toho v
t=C3=A9to transakci chci, abyste odpov=C4=9Bd=C4=9Bli d=C5=AFv=C4=9Brn=C4=
=9B.

Julius Proctor
