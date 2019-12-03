Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4C931104B0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 20:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfLCTCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 14:02:38 -0500
Received: from mail-pl1-f180.google.com ([209.85.214.180]:44453 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbfLCTCi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 14:02:38 -0500
Received: by mail-pl1-f180.google.com with SMTP id az9so2040642plb.11
        for <stable@vger.kernel.org>; Tue, 03 Dec 2019 11:02:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L5H4Xe75fl+vzycgJu0P2w0Qk1+hy9/ufFjW3O7EOe8=;
        b=FUaWxfjRZzMNPXx5aGskvrQgah0dYPjCMcD6w48G5E6JvzAkzZwE3LXRb/OPcbKmum
         kHXQr3lH6nVo29v4ImbHkQi72gIsMVeU1XhPgfxIwpaJz6lX3vvozTRAS9njfml+kz6v
         IjvISWrzcrTGjnrkqS7QlXPZLaJomDPBTuGrKoreP0xuE/kUdWDXgiI83zmxkr3yV4Qi
         7dUoG3cyLKu4e9rlsiI4COOdImoiRypOyH/IzYURIfdx/JAn1DPxTMUG7PjfrYyvP1ZD
         arQqlV4Eeh9Pnr+VrWPEVQBPntqg0GbfYw0cwm1EBuAyqQ4CJLHBVJicS9qcArVvIUvW
         tYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L5H4Xe75fl+vzycgJu0P2w0Qk1+hy9/ufFjW3O7EOe8=;
        b=LGneUEL+VzZtpn39wyNp5la+erW+7DnKWradbrkLI3N8AxrhLRRxImzOmqYZbAjvUn
         cKOTbBOcTB7Xl60HCcdoBUSF4l0qlfEO3zj3IDHEFHwDUK+lcdgfTU4z463niMM3p8BK
         tEiNykTw4tfWUnMWS0gGAFqeCDgBvubPGwq1SkVZGNG+eVTEbpJmzxGWvKiUtrdVjF2f
         yT3tTuwjeLadb1YF3wLJ/Ho3K5em8MlPWAW/e9Jhi5UsF5LFVgv0++hFyvGw4xQ0lWa2
         +Ntx6b2IYr6WpVYfRb3fhOPL/+REOqT2j4xE/bTmfUWEX8naZutZX9HttsKCPcLxj8Ia
         lIBA==
X-Gm-Message-State: APjAAAXqdmLQso+59qZYvOIh67xxxOgJ9AE0muDSuJPoloaaPuT1sCDk
        S/P3wuGytvGW9tluBwBO8zNXeFB/ajI=
X-Google-Smtp-Source: APXvYqyatPNZE5cDSuG/iaD7zda/2EC1IqEoXRyMU1zAcq5XradY7m6Yqa4xdK/h0fPlQy0Nsk5A/w==
X-Received: by 2002:a17:902:bf47:: with SMTP id u7mr6483128pls.259.1575399757662;
        Tue, 03 Dec 2019 11:02:37 -0800 (PST)
Received: from localhost.localdomain ([2402:3a80:13a5:68f8:3984:ab1:9b44:803])
        by smtp.gmail.com with ESMTPSA id r3sm4915687pfg.145.2019.12.03.11.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Dec 2019 11:02:37 -0800 (PST)
From:   madhuparnabhowmik04@gmail.com
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel-mentees@lists.linuxfoundation.org,
        stable@vger.kernel.org
Subject: Re: Boot Test: Linux 5.4.1
Date:   Wed,  4 Dec 2019 00:32:32 +0530
Message-Id: <20191203190232.7816-1-madhuparnabhowmik04@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191203063521.GA1771875@kroah.com>
References: <20191203063521.GA1771875@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

No, it is not new, I boot tested Linux 5.4.0 and Linux 5.3.1 as well.
I got the same error:

[    0.275651] platform MSFT0101:00: failed to claim resource 1: [mem 0xfed40000-0xfed40fff]
[    0.275657] acpi MSFT0101:00: platform device creation failed: -16

Thank you

Regards,
Madhuparna
