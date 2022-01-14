Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB16E48E91A
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 12:21:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiANLVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 06:21:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbiANLVx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 06:21:53 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C6DC061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 03:21:52 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id 78so5631280vkz.7
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 03:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kpUcp1C4bSuHNDFQytz0j7wDCPyhL79Fhgk3inyUId0=;
        b=xVjc5vkEJnFQEZFQG6LbHcffzKsk59jvStgJtqFfd7VBUHTbRaiAltV4gWA/ZhgJUr
         JLL/GI8l7PvtLlLKxhgHp8kpDOvlPJvgpU1cATZIvlU0QLwYhAJnLd6YFzunHlpaX1ay
         IWwSixWA0jL1p1LEwnu7r6hBdr2i64G2ofNwDNaC/yuOgpUDodvwrXZZYhZVbuXxr8jQ
         AIfmBSuOKpL3gCbIRdp8D4AoN0lXkmyzSd4xy9/9WykjkO49zvvSC5fcwaMVGOHEJor0
         0J7KopZwe4VBHH0IL+omUDEyRLOQZ95QGZM3hBYR+Wfjwke4t89cw5ipEL8T13MI4hx/
         pgVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=kpUcp1C4bSuHNDFQytz0j7wDCPyhL79Fhgk3inyUId0=;
        b=cExdyZ1reqLwwPndTp3jEy7qWPrc50ot2fDm15auqYbjHbuqKCX+uIRc4Rq8Y9lEaI
         7LSyU1+p8Cz/sOM8RS5tP1nTw3Y4zbd+zRy1zNGGzdwRr80OuvyhKdV/i1NaDAiFsPjQ
         CM6oxVoiNu4QEkARN/0wqZR1ycqMp/+PPUgKligjayr724TkR819bfWE48lrgriIOlFu
         YRd/lCy+VDN/6nTAsg5jvR2a89giW/NzYSt9BWOQIaZTcfspWOb2SwFqx6tqBKEyPuQX
         mJXgsLTTJH5U0CNifpxXB/o2dOnvzf+WEHY3C0+WmG695KhC0XnrW3axSFl9CX3gIpYz
         3SNw==
X-Gm-Message-State: AOAM530uA0Nj1OUClpeTQc6IUuqVZjAifyIC9wdincfKi+aZ1GC2dlR+
        kIdk5D9YnlFz4NhjZ0PwOkJi46cXbWFMCh8pUc1p8vu2ygaSXg==
X-Google-Smtp-Source: ABdhPJwEQu7KA0KPfcUGzVhceTW40PKGVtUXl68CdhtT5AYw3TpMaSt2suBfM/eDrNdH2Tj4yR8P8GkyQcqbr0TTrcA=
X-Received: by 2002:a05:6122:1352:: with SMTP id f18mr235031vkp.29.1642159311776;
 Fri, 14 Jan 2022 03:21:51 -0800 (PST)
MIME-Version: 1.0
From:   Lee Jones <lee.jones@linaro.org>
Date:   Fri, 14 Jan 2022 11:21:41 +0000
Message-ID: <CAF2Aj3g6Z_vVEUDcESkJMqTZ_Ljr7GQXFCFdLmFEq9yQHo7YPQ@mail.gmail.com>
Subject: [BACKPORT v4.14] bpf: fix truncated jump targets on heavy expansions
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Could we please have this in linux-4.14.y as it fixes a CVE.

https://lore.kernel.org/all/20180516234411.18122-1-daniel@iogearbox.net/

050fad7c4534c ("bpf: fix truncated jump targets on heavy expansions")

Kind regards,
Lee

--=20
Lee Jones [=E6=9D=8E=E7=90=BC=E6=96=AF]
Linaro Services Principle Technical Lead
Linaro.org =E2=94=82 Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
