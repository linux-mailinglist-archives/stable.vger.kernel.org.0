Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E94030B0C2
	for <lists+stable@lfdr.de>; Mon,  1 Feb 2021 20:49:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhBATsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Feb 2021 14:48:18 -0500
Received: from mail-pl1-f174.google.com ([209.85.214.174]:46346 "EHLO
        mail-pl1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231713AbhBATrD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Feb 2021 14:47:03 -0500
Received: by mail-pl1-f174.google.com with SMTP id u11so10590436plg.13
        for <stable@vger.kernel.org>; Mon, 01 Feb 2021 11:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=qKGuAiE+/RAIRsEynoaXnRLuGpF9KWJoin7LdeD8PG4=;
        b=AHgpCPxRecdelOTD5OK2q0e3Zg15WBCXRla0nxFWG2LDLgL47Lb0byZjr86pmEYAsZ
         GSs5RKjQzhMnh1zE9XscgugfvUs5PRBmqmtStBbcZ4HTpgcmdCqInvINxlhs9Fz9GQjr
         aGFnmMjBoxhjTnGNuTizpPM0YYe9qOmw0K4deqEa2yReRIk1KZyJn7Ot/ZmjVVJZvN6a
         yOsEn+T8w9FGhVldgcVkRQzfyxnyVNVNu0135KsKTAWTRLJgrOqO+5/C1G2XlAEJz75I
         KNqNzRpjxTjMZOc/kIR3GNPes1AgPsMsrNoU49Fw2RDbAVoWw5ZN1YzUsLdZf05fnldW
         bZvg==
X-Gm-Message-State: AOAM531Kg6tvuBS4AYz3xE5+Is0BC90bYgTfYfh1uCcKhb3yEMbdrEFD
        1IcoRgKkovJhMHvUvD6JkfoCGR/CcbHGTw==
X-Google-Smtp-Source: ABdhPJzaWiwCGU/AY6/cJMw9p110jcjV/mbCl4DLPWssrnCWL3k3Tbs/BWqx4TU/O5kALpfhMrw2Pg==
X-Received: by 2002:a17:90a:cf95:: with SMTP id i21mr457479pju.95.1612208783064;
        Mon, 01 Feb 2021 11:46:23 -0800 (PST)
Received: from localhost ([2601:647:5b00:1161:a4cc:eef9:fbc0:2781])
        by smtp.gmail.com with ESMTPSA id c185sm18529760pfb.178.2021.02.01.11.46.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Feb 2021 11:46:21 -0800 (PST)
Date:   Mon, 1 Feb 2021 11:46:20 -0800
From:   Moritz Fischer <mdf@kernel.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, moritzf@google.com
Subject: Backport of a1df829ead587 ("ACPI/IORT: Do not blindly trust DMA
 masks from firmware")
Message-ID: <YBhajBbI3J3+O9CP@epycbox.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg, Sasha,

Please consider backporting a1df829ead5877d4a1061e976a50e2e665a16f24
("ACPI/IORT: Do not blindly trust DMA masks from firmware").

It should apply all the way back to 5.5 and addresses an issue that
affects one of my machines with broken firmware.

If that's not feasible, at least 5.10 should get it.

Cheers,
Moritz
