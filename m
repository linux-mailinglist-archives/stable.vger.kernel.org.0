Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3338A10CC89
	for <lists+stable@lfdr.de>; Thu, 28 Nov 2019 17:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbfK1QOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Nov 2019 11:14:14 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:36544 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfK1QOO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Nov 2019 11:14:14 -0500
Received: by mail-oi1-f196.google.com with SMTP id c16so1573936oic.3;
        Thu, 28 Nov 2019 08:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=HXjWgP31PN/DWn/Gi3jgWnG/yRkcUzhgwC3ec6Y3wKE=;
        b=P+fUHApHfs+U79n9TrrAJgWExK4Go+XQ2giLCeFimABlbFnZtibZeX2rxpNdiYXJOu
         WWP5w5Zu+1XnzpqaIXb8lYx1epECbNTCRqfEqIbQN1EI1osJNMpsJAEiD3W8nbkaXJMF
         An+P+A/KS4G7M5VRs/lveJH3W03iBRBFxf9tF/j1v83fUg7xfZ4ozClXGe5PHYenE3+q
         zuuwNQoEMc0tChPNn39VUPKPCvJurhBw5VLgWLvUfrrwt90Dj4gUYt3MbheklT6U6Sg/
         yXYMraMV8MHxCrZ1mjeprAx4ZRpo1FeDErXQYHrT/3aoy+8GxTVI3Ujj6tGd0cZu3ZPK
         MA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=HXjWgP31PN/DWn/Gi3jgWnG/yRkcUzhgwC3ec6Y3wKE=;
        b=GgtQrlNcf0lm5Ou+UDi2XuJ2zrldddmdqbr87bK2AwuneQlv+NDrTy3QdgiacKCsAF
         DZ+CuutM6f4oqZnZ/yVHc/VDe3fCcqDAlbegyb9AJVuAhtntstgo/QpUvSdpbu/0686v
         7K+Co2JDu8VcYNAllk2t2yut7TkvV/u1YaCU+jPWto5mJpcvMbKlPLzEkv6Pj2kqCx9Z
         5/QAH8/asTRvLTIeS6KbPzy65C8wZaXkyliY1jug6ywiM7w8Eog63LX5XzHUCuqmt0uZ
         cCD/bZmJaHqJuO73W/gg2kpXIDM0mfUxTqKHSoAmFmwniB+WX13G5NMPCCfJMLKlAREZ
         XY2Q==
X-Gm-Message-State: APjAAAVisbdxoLpyoME2pQGYgBA1ftghU+klwL7oHVvK3oH3j7HSq7c0
        dGnFHIBJZVC8wVdyV68OIosnqM81
X-Google-Smtp-Source: APXvYqyOTtO4PjTIxnCNOdt2Y32h42qvaK+xClRrWlm6WtvVhpYyz3PylXp6B8U3WNszEGUMy38nPw==
X-Received: by 2002:aca:4d0f:: with SMTP id a15mr9117057oib.21.1574957652899;
        Thu, 28 Nov 2019 08:14:12 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x11sm6223187oie.25.2019.11.28.08.14.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 28 Nov 2019 08:14:12 -0800 (PST)
Subject: Re: [PATCH 4.9 000/151] 4.9.204-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191127203000.773542911@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <7468e29f-2ef1-59f6-8f71-f073a33b4d0a@roeck-us.net>
Date:   Thu, 28 Nov 2019 08:14:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191127203000.773542911@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/27/19 12:29 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.204 release.
> There are 151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Nov 2019 20:18:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 356 pass: 356 fail: 0

Guenter
