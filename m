Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88EB683478
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 16:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbfHFO4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 10:56:39 -0400
Received: from mail-ot1-f54.google.com ([209.85.210.54]:38894 "EHLO
        mail-ot1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732976AbfHFO4j (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 10:56:39 -0400
Received: by mail-ot1-f54.google.com with SMTP id d17so93266342oth.5
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 07:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gT1v112V4KiPIlW0FjGcMSYpAyH3mKR6rypffiWhHdQ=;
        b=qizMGl1fGRLFYkl7eGq+4+vIx7xZuFSrPota45TeHZFckzyc75D0sWoCSEXBy+27Tc
         2fDZce+7pU/HgiDVvVueeuyj+cN/Mxf9rfcEDg2FY1WYWRczvdvrma228yFxEGCZYn14
         kzXnzw6Q7QJFov173hYf3JON2f28HZ7//8W5chh/fJyJvIAZmhPWsUjkvtCrj+mppt7U
         FK+zJ49b+YDvasMT0KrKYyRmroh5LrrHE4AqqDEMzNaH6BeNG/5OFQBRG96BtKcjRVrZ
         rZ8UFS0GeS1JDe1E5cajfpT05jU4PxPW+2vUcm+5j8V3DKO6Ow1NSulU6QzMEtDzoXEx
         Jt5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gT1v112V4KiPIlW0FjGcMSYpAyH3mKR6rypffiWhHdQ=;
        b=Iu28dZrlLRQsNSvgm5yqZfXzjVo0xy7XhiE1bowkZS1htN2jPhNDbaMftJXuEPTrgV
         HI+1R79Vx4D0hN2wuAuK3Y/pT4/vDxi9TBHuvW+fpT/Z2lRKVfdjyQ5a+/03LqnklCpH
         iKldjmjG8JOdpX3OWffVEJbLkrP5qdv3ceytNigzg6zldU6TIYZRujM6Juyk78wBtU+I
         SVooEXmZ8wjo9XK3ZKbUUnnPst5Rwd/JTL7MOwDhX8MLaa4iCk6ROsR0dGAsySjVejNA
         04NEYetaU16obu0kFui9arpJx15VGqHfLI5Bq804oo5QDY2FUe8AabDBD+M0rJlEevum
         d+cw==
X-Gm-Message-State: APjAAAVDTiLB9N6i5rBBGSnj50g/cezro3kC1A+zEvW31no8fiQn2blG
        vaxPgpwBqZKUWmIq79BburONLqC4Gv2fpc/msjRucHSk
X-Google-Smtp-Source: APXvYqxcleDvCXPKObdsTeN9HM0ev3koYlJd50Sg78U/GaHLiXn2p3gwRZ2KQQnQgHWKNvjXeRqA39KkfPedPd+wF2U=
X-Received: by 2002:a6b:621a:: with SMTP id f26mr3166993iog.127.1565103398326;
 Tue, 06 Aug 2019 07:56:38 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 6 Aug 2019 09:56:27 -0500
Message-ID: <CAHCN7xLyZAxK2L0+bjT9a+aZXtjmCtTRP9kC2Org9=R1rwf8yg@mail.gmail.com>
Subject: ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD torpedo
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply a135a392acbec7ecda782981788e8c03767a1571 ("ARM: dts: Add
pinmuxing for i2c2 and i2c3 for LogicPD torpedo") to 4.9.y branch.

Ideally, it would be applied to 4.4, but It doesn't apply cleanly to
4.4.  I can do a separate patch to do that, but I am not sure of the
proper procedure.

Due to some changes in the bootloader, I2C2 and 3 may not necessarily
be muxed properly.  This patch will ensure it's working for the
various devices connected to it.

adam
