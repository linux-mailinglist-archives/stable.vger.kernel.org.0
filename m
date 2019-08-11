Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B703891F4
	for <lists+stable@lfdr.de>; Sun, 11 Aug 2019 16:06:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726424AbfHKOGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Aug 2019 10:06:01 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:45883 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726313AbfHKOGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Aug 2019 10:06:00 -0400
Received: by mail-pg1-f194.google.com with SMTP id o13so48180623pgp.12;
        Sun, 11 Aug 2019 07:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=aoUxeR/oeVMpM3Zj84G0o28rUL2CzzLDi2jOscK9ZeE=;
        b=X1F6KmZAwq+SoLMW5skMfI5i4y0CfAp/AAdjkGvpq9MnOgahkvYhvR+jq77kvp/Caw
         cqiWMEwb1jLJ+dkt4IK5DwM1kPvQQIYffzDWjGizm21r7FdfqmRJ+Hpkz0BxqdwZGAKn
         6B7DLp2K8nRRZIiYtqvMNickv19nLDxBk8CTk3WnKUUt+Hfte9ioGogHYVfcIQdIAyp4
         wbGi0PqtD/d1TSHYdkzcTOGjkQ4+h+d7MkARk4XYGr8BG2gyroCCK4SG/3JMtZla+uEJ
         iKhq1rhMvCdZRXuIog3AgI+Brt3ecaI9/lWhvO9iGcjvJ2CM2SRO0t/qu8/mZc+G4EtK
         XV/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aoUxeR/oeVMpM3Zj84G0o28rUL2CzzLDi2jOscK9ZeE=;
        b=fS+F1JuBKqiifF3ypTKXroHZgAjo7naPkp1iluBlpaSquKc95R+/AA18VNkYFYevH4
         BnVVWlGFN21026/8CrFS9Lv0m4FqVxjKOVqBhexuL9G6vUV4n/Z1v36lw/xIcNcXsuMd
         MlbYt8iO8UdQbcOEYYZZ3WHy0xLPsyvZsrXehK07PxKNEia3zxCcfpvWBXYuQrtRDb8x
         HpDkl7JIFOe8U4wNdOa5oxUg67JH0RDOoJohWdi7y8mepsVcKTCK/K/z8Gmsn/5J5NIB
         SgJdgbpqNOsuW/sP1TMxSuEauvzJ/MG05uDkqXbZimjhraiUCFAi257c6lEaxljhJnra
         dQ1w==
X-Gm-Message-State: APjAAAUrHEP348pXQsK2q4/PihO5lvVIH1/AqCSX/0YnnmxG+eVQsev7
        guCtxwM6DSFN5LycYPS9CR8=
X-Google-Smtp-Source: APXvYqw8uJ2EKUFkGcN1DJpPAi/rC2VvTXQnd/Htp0Yz7OvOO2MqvtqyHI1TBxiawVAp7/x0mJUUNA==
X-Received: by 2002:a17:90a:9f01:: with SMTP id n1mr5628675pjp.103.1565532359897;
        Sun, 11 Aug 2019 07:05:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n185sm91094383pga.16.2019.08.11.07.05.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 07:05:59 -0700 (PDT)
Subject: Re: [PATCH 3.16 000/157] 3.16.72-rc1 review
To:     Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
References: <lsq.1565469607.188083258@decadent.org.uk>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <06733f55-19b7-6192-736c-fa1014f120ea@roeck-us.net>
Date:   Sun, 11 Aug 2019 07:05:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/10/19 1:40 PM, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.72 release.
> There are 157 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue Aug 13 12:00:00 UTC 2019.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 229 pass: 229 fail: 0

Guenter
