Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30FF613959F
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 17:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728800AbgAMQSc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 11:18:32 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:42545 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728792AbgAMQSc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 11:18:32 -0500
Received: by mail-wr1-f67.google.com with SMTP id q6so9164809wro.9
        for <stable@vger.kernel.org>; Mon, 13 Jan 2020 08:18:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=iVxxrHp+h/CeS6Uvz+VCk6mmS4cds+n/wJYC9F2+S6I=;
        b=NS5hFbzKF7a2BxuD/am3p8nh34eZUBSBxeh1CnO9h0dUi2BMhvWvKuPFVJaK84uNaJ
         d4vD1vl2Ps650dFs6bLdxSweyXcTyQOXV/PM71zhb9A1X2YcORxezKVRV+dPK2Ej4m31
         M1bO9/GzM3zBgtSV060fmFTGhcVbhABLZGHPGoqFWIRZ6KSdpRuMsazLUcLiaoy+fC43
         2L4S9CDHTrdRHz+NAhPfPJyKI/koz4RXVo/n29e/3aibF/l5N8H806vmBKoGGUpmbqTM
         oMWQFwnsIo6mZF1uj1ehGiQZGb5l1SwmSqDNI+M5U1BtrIAACl7cv0pqqKydIJULPD+v
         VsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=iVxxrHp+h/CeS6Uvz+VCk6mmS4cds+n/wJYC9F2+S6I=;
        b=bNShDCgCti4iwzpQfVMhj3BWvCDzkv6QLxGrwY7KuDIF/o0KwV0btkEdQA+MoyhWD3
         fRHdm03KxqvmRes8YT3q78Ufp1EC4kYlVidAMw9OgYHKQivn9SCmMEUx4mP5ymhObAsn
         QT+giiFbRwpPOvTKs36kyPNC2hK24hKFxslQAKgQP/xIMNOhDCSWqydkRAs9eauZWh/U
         qdx3uNMjt/1XH8rc4at4cLHYX/XQJLEOVI/Y2+dhKowtzgUDPPafssIo192udQNY/foT
         0928UM+qxGmea6DppvOQGfehFrlHwZAwN9AQIRp7rPFYKXr95rKG1kYZV7ascBY0Sd0V
         +W6A==
X-Gm-Message-State: APjAAAWtOn8weHaUWjDRHFRzsYqRmWtHb6w1lSwJJL5xg3FCPmz8Bdrb
        UWJIDoe2hclRW8TlAzHcjOA=
X-Google-Smtp-Source: APXvYqwDx8GfhUKWO95fhE9aM8ZjCrXVAPYOIv/IupuPI+/jlKoO0hwSnIG6XGgyTLTEqnK7yKqqOw==
X-Received: by 2002:adf:b648:: with SMTP id i8mr19713384wre.91.1578932310129;
        Mon, 13 Jan 2020 08:18:30 -0800 (PST)
Received: from lorien (lorien.valinor.li. [2a01:4f8:192:61d5::2])
        by smtp.gmail.com with ESMTPSA id n67sm15372504wmf.46.2020.01.13.08.18.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jan 2020 08:18:28 -0800 (PST)
Date:   Mon, 13 Jan 2020 17:18:27 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Please apply 0b9aefea8600 ("tcp: minimize false-positives on TCP/GRO
 check") to v4.9.y
Message-ID: <20200113161827.GA22400@lorien.valinor.li>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, hi Sasha

As per https://bugzilla.kernel.org/show_bug.cgi?id=194569 applying the
commit 0b9aefea8600 ("tcp: minimize false-positives on TCP/GRO check")
would reduce the false-positives. dcb17d22e1c2 was introduced in v4.9.

Thoughs? Can you consider applying it for 4.9.y?

Regards,
Salvatore
