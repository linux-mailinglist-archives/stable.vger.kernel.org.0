Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF4D3D952E
	for <lists+stable@lfdr.de>; Wed, 28 Jul 2021 20:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbhG1SVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 14:21:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhG1SVa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 14:21:30 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC89C061757;
        Wed, 28 Jul 2021 11:21:27 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id az7so3166727qkb.5;
        Wed, 28 Jul 2021 11:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EAtzVB7QTzLT44erGp9KPPEcRNvosg9DAAiiYrA21Ys=;
        b=UkFUCMU0wJ/y20fw+y0FpGskgrf8mX0BvUIhnRKtbI8QXJEQcwtAq+GRMkFMClckSD
         xPyVyz1DqoTFkg1/6P1UQ7Uhjr30SSqn0aNPRZ9Re20Twm1RxnRAU9JrEfLIb1O+HCd/
         zYI0TVuLQVB1UShA4VVh5vOdDkqx+7NchDqV6RdTBU76uyakFtw5KwE6SDZqJIn6HXn5
         MrkOmBrJBhZVrGofE05tOyZhRs3hRiSooguenii33OYKg6J/ovJak6VL4RUVpWq3Fzu8
         C2D8U/dbQLAusgICRtbSYilC4jFY7AYdrHVe6b8vQHT7LmF5kPjLADhhdVTym0xvRJ5O
         RCyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EAtzVB7QTzLT44erGp9KPPEcRNvosg9DAAiiYrA21Ys=;
        b=oJNu//BncQGbTilzD2ne0AJOCJb6eE019YEUkvH1axvd4j0fhHg7l1NnA3wLg8V9+D
         Ko05iItKIiZOONt/IXDXCOJkA8af/GPCy4E8dXQEeRM/mYm33t/xkuSOOUkUx7tMb7K9
         H7D/4xqFjyv4YPZSgQE+VVJH3zfQL1yGt3kNbwVZdXJkucKm39JIGaYvtoGqTXrqopaF
         xmIJKLutET/u9OK8k7dViSQzva6YWR9feFNSqz9MTTS7fJ+8hV2CXdo2gXHJcWTBlsM0
         azvKMcLQy71SeTmy8YD8Ajg0O/J3XsB5z+PfbrUHVgnU5fLLcHpH4VpNCbIIQZEmbY8d
         L0/w==
X-Gm-Message-State: AOAM533tTvcujrAZe/72VF7jgF98cV+NUneFiwl6/ZdwXuIUd6EvcnYb
        B+PtEZfvcOIZusrrPsrzul/GmWbEb8L3Uw==
X-Google-Smtp-Source: ABdhPJwNyDJM4q0Dm3aDNB4XW+1csADWYGqiX/sdr7mNAlChV7XCbY9VpeM+rB0YF+xpLUDcoUEa3Q==
X-Received: by 2002:a05:620a:a89:: with SMTP id v9mr1022003qkg.232.1627496486504;
        Wed, 28 Jul 2021 11:21:26 -0700 (PDT)
Received: from mua.localhost ([2600:1700:e380:2c20::47])
        by smtp.gmail.com with ESMTPSA id r13sm265352qtt.38.2021.07.28.11.21.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 11:21:26 -0700 (PDT)
Subject: Re: [PATCH] Revert "ACPI: resources: Add checks for ACPI IRQ
 override"
From:   PGNet Dev <pgnet.dev@gmail.com>
To:     rafael@kernel.org
Cc:     gregkh@linuxfoundation.org, hui.wang@canonical.com,
        linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com,
        stable@vger.kernel.org, manuelkrause@netscape.net
References: <20210728151958.15205-1-hui.wang@canonical.com>
 <YQGA4Kj2Imz44D3k@kroah.com>
 <CAJZ5v0iKTXSHRU96_xjnh4Zjh4gNfwZs9PusrX3OA059HJNHsw@mail.gmail.com>
 <a27b6363-e8d3-f9ad-5029-a4a434c6d79b@gmail.com>
 <CAJZ5v0hkXcouTpF0Hmv9jUwHytOZRz0-T3TYGwzodT0EJYqRjw@mail.gmail.com>
Message-ID: <0a782013-c0ba-3220-641e-7e7282d09746@gmail.com>
Date:   Wed, 28 Jul 2021 14:23:39 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <CAJZ5v0hkXcouTpF0Hmv9jUwHytOZRz0-T3TYGwzodT0EJYqRjw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/28/21 12:54 PM, Rafael J. Wysocki wrote:
>> Will this revert be auto-magically backported to earlier stable (5.12x/5.13x) trees?
> 
> It carries the Cc:stable tag, so it should be picked up automatically.


thx all!
