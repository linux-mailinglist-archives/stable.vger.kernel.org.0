Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1CF85A108
	for <lists+stable@lfdr.de>; Fri, 28 Jun 2019 18:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726686AbfF1Qfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Jun 2019 12:35:37 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:35298 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfF1Qfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Jun 2019 12:35:36 -0400
Received: by mail-lf1-f49.google.com with SMTP id a25so4393162lfg.2
        for <stable@vger.kernel.org>; Fri, 28 Jun 2019 09:35:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=nwVfPs+vIRBiktClscrgxMmqQM1hwDrGpHuR2rGCVDY=;
        b=Plfim1NXgj5v/s46QIZwG8klsFrLxM5m5FEGeyefHkg1Z1PO6BNhCJNyi7OF2vsSJ7
         O0MO4lBdIUfpbICWOguX/StdWgyohHhOPfXGQl+daxKLBmozUh6uTBXqghzUQUjKX4cn
         zZPJDuk7hrdgs6Dr7q8d3HZzRfA2om6hGi2qNSGjeHquGkyyEPVr1+CJNxD1DzW9UyZG
         I87sLWLVYdkjNsJVbIJeEVGGrz+j8eG7o+0IC3GmelP+bXsknG2yuzAXkG6ZZ6f+U3N1
         6gCfcUY9al1+ffLNM4DeI2QCQQ9yUPZS1xLE7+1NVOhz0Zc19W9FmfVpbQJ1yYVPETlf
         kYmg==
X-Gm-Message-State: APjAAAUf4yG4lOYIJSUKBI4TgnfiscLtxN9Q5wUeukoePoVvwJdlYGb1
        TQCtCYA1oVO2VkT8A56/bu8Hsk5WOgDrFQHSQV87K14/3fU30A==
X-Google-Smtp-Source: APXvYqzJTO1posPWsyifEBPmyg1q49r/NpZ6fZUXRp3qxp05xvQunGF0v2b0fJs5viNlmGejRJivqSb/XkLwXVI68Qc=
X-Received: by 2002:ac2:5a01:: with SMTP id q1mr5546835lfn.46.1561739734447;
 Fri, 28 Jun 2019 09:35:34 -0700 (PDT)
MIME-Version: 1.0
From:   Matteo Croce <mcroce@redhat.com>
Date:   Fri, 28 Jun 2019 18:34:58 +0200
Message-ID: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
Subject: net: check before dereferencing netdev_ops during busy poll
To:     stable@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Elsasser <jelsasser@appneta.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

Is there any reason for this panic fix not being applied in stable?

https://lore.kernel.org/netdev/20180313053248.13654-1-jelsasser@appneta.com/T/

It seems that linux 4.9.184 has the bug too.

Regards,
-- 
Matteo Croce
per aspera ad upstream
