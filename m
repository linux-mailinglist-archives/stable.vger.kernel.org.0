Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E8E9834B0
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:06:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfHFPGg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:06:36 -0400
Received: from mail-ot1-f42.google.com ([209.85.210.42]:45929 "EHLO
        mail-ot1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726713AbfHFPGg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:06:36 -0400
Received: by mail-ot1-f42.google.com with SMTP id x21so27782000otq.12
        for <stable@vger.kernel.org>; Tue, 06 Aug 2019 08:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=gdopTHCwMPwb2EOwXXT9O/ZQ+AObSyEafju1N9XrQ7U=;
        b=hyMB34SFxH8ne4R1EcGnGeGd4f0Lq8IzaUCbukv+IZ4zGeAPldQPwmgtcNT8I36O2C
         DF0Jonpg1s272TbP8Q4Mou5iQ14li+azD6XOOyHFAJSIrB2xodynbc0lrX6clQU6gfyQ
         Meckat7D06pkCqz4aFvQKFPjj1X6fJDmRxIuVh3HHcZA0YV41RI/bk/7Gxfumf8nZ9Uj
         6ncyoJ3+HQDR1TB7ttY5PJcB2ZGKCvs4OlSzYA5PEYC9C9qfUuopOum5UmVO+maw3JES
         9jQsSFVXXH9ZxMjl+SGxMO9fO54HCI1oitcmDLEkYEgabz4o9pUVQ+0R5i05E5vM3tSM
         J60A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=gdopTHCwMPwb2EOwXXT9O/ZQ+AObSyEafju1N9XrQ7U=;
        b=k5tIC4+qRgMEBTKcCz11n/NiLD2pYzw1sEPqzUsnMYulhT2wfodS0v3jDOvkoPs9Df
         bu46r+HjDu3v0+pV1F7UzhELJl3pC8PJrZbL0Az2ftoOACe6r81SuX7RiFi9YGDmw/x5
         pRSE3RqqDsWRhTOmoOhH1nR4uiRYTT1Abf8Tv6+FZ04b/ICG0eVtFhYIyTlqs6IXKhNN
         BAr0g8wT2wKTAU80TWKSjxlYE8ngzQnJWf3XNZNMbhtJxYGa2Awclmi4CZ/lhERIh++s
         +Ncp12KQtMl0fH/SgnJnOYa8Mx73rXg3JohyFE5Vmsi65EVuaKcSpwNplBvBH1ttLrn/
         LdxQ==
X-Gm-Message-State: APjAAAW33uVAdh2DE80TM1tblV3qwPd06Y9k2BcBi38Uw010VglidLjl
        T7tLif9UCaABm0eyGlaZQGRyBZnegUQSmrAh1w2N+OdU
X-Google-Smtp-Source: APXvYqyKOIx0j6HcVnJRqV/oqZo7p13BtrUhRzcrUNXTPLpyXt8R4khcFauQTykI5s95RwclX6EfHtIDwDsBna1INfc=
X-Received: by 2002:a5e:d60a:: with SMTP id w10mr4295347iom.78.1565103995496;
 Tue, 06 Aug 2019 08:06:35 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Tue, 6 Aug 2019 10:06:24 -0500
Message-ID: <CAHCN7xJUd0ZmC86_NsS+8j+o5M0iQipGJuh00nV0=V=qt5Jtaw@mail.gmail.com>
Subject: ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply 5fe3c0fa0d54877c65e7c9b4442aeeb25cdf469a
 ("ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV") to
4.9.y branch.

Ideally, it would be applied to 4.4, but It doesn't apply cleanly to
4.4.  I can do a separate patch to do that, but I am not sure of the
proper procedure.

Due to some changes in the bootloader, I2C2 and 3 may not necessarily
be muxed properly.  This patch will ensure it's working for the
various devices connected to it.

thank you,

adam
