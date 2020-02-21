Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3764416804D
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 15:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728392AbgBUOdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 09:33:20 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:35268 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728312AbgBUOdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Feb 2020 09:33:20 -0500
Received: by mail-pj1-f65.google.com with SMTP id q39so826837pjc.0
        for <stable@vger.kernel.org>; Fri, 21 Feb 2020 06:33:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=eODhXq536pPyhBuVt4EWzyRZ46IbqCFOAW0Gck0HY0g=;
        b=U90Zbv3BiRJIYU2RHRbzx0U9WblqmFAQ4BhIlfD7JzFYJ+phI6QCyTCgJhDqR8jMmi
         4zsN6doDbeZVQBPWQ8TXmsnYv90XM96RVcrzUBfy+6aa9k40EgPKpbYx6E24U6Hy5GnW
         Jt2Hu5xnaHq+8dfbXcxytqIYmb/2gcb8v4VovBw/1Nd+2HLPyzKezKCCgprXEdnPVCCJ
         9Qyi/4KwYUj4v23kON83Ltyve5HKglrOo+K+jiB+2cHr1jReVXVB61rLyH+bcVqSuDdF
         9gIbVT3jmnxTCWy8hweH9LBsF7k88LFAN6cSlxz/JnkhVNFKmZ+41Wq90NBhLqbSmY+B
         /SPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:from:subject:message-id:date
         :user-agent:mime-version:content-language:content-transfer-encoding;
        bh=eODhXq536pPyhBuVt4EWzyRZ46IbqCFOAW0Gck0HY0g=;
        b=oxWVPDM0+1sfpb3fAD6sCBkdwAKyBhK7z4Bxkbo41uSLnXG+9no6KZ7DOGoCvcQtWU
         2mHT16oFtwM1nJ1Hmc3XvGH2nNvG91D1Sjlr/VZy6lna9A1OprAcfpiZL4fgoEPPg6AD
         DUjMI0cWuBIYSzDa6S+7RwpdYtDZJ780RVT3y2gdxZbEhpYt9GxoxQoerj64RonsMzcH
         75JE7rbuxz9Qeq9RWGHHeiw23RlMZSDujVlRotZxkj0jEzWuGN87/2xgO0I7+ZvKsQuj
         5SjMIlenWI7kLU3pZ7nhQ27iSFUPf98HYQ07ChYy/7p4mfuKbKY+dmfwyH9dLLD1iPgk
         leBg==
X-Gm-Message-State: APjAAAWUVN/DGfm4gcdhPeTa+yZocEDbWrYH6Zu/Wo4/O8PGb0rRM6ZZ
        0V2aQqN9IjMFgmiBh9QRfksgRAfU
X-Google-Smtp-Source: APXvYqwK6lujFmLxhSpTO0VCfCFOa+31bEXxWJch++d1hFyybEeRkvi1n6teXOd1c9I+Gii5JjibRA==
X-Received: by 2002:a17:90a:d103:: with SMTP id l3mr3617700pju.116.1582295599552;
        Fri, 21 Feb 2020 06:33:19 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g13sm2707094pgh.82.2020.02.21.06.33.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2020 06:33:18 -0800 (PST)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Build failures in v4.9.y, v4.14.y stable queues
Message-ID: <adb8b3ba-16c4-49f9-0160-3522681b49f8@roeck-us.net>
Date:   Fri, 21 Feb 2020 06:33:17 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Building arm:allmodconfig ... failed
--------------
Error log:
arch/arm/boot/dts/sun8i-h3-orangepi-lite.dtb: ERROR (phandle_references): Reference to non-existent node or label "cpu0"

Affects both v4.9.y (v4.9.214-119-gb651de82f0d1) and v4.14.y (v4.14.171-173-g611d08c2bab0).

Guenter
