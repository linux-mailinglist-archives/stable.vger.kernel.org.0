Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 71329D33D6
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 00:19:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725978AbfJJWT5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 18:19:57 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44673 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbfJJWT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Oct 2019 18:19:57 -0400
Received: by mail-pf1-f193.google.com with SMTP id q21so4778060pfn.11;
        Thu, 10 Oct 2019 15:19:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u/5ZAJi0CkaRF5CIqKAmErm1uNaTzftysAnpXOCQ4TE=;
        b=A2z0f4LOwBhmMX4jddgyhcUB/VZUTbh8H+nGIfVACuLYL+Eq+xeITL+KE+rEh/gOia
         4tX3ATOjWcCyGTUQSUJGKdjCkQcQx9d47JFIAGG2biK9f3Ltc7oX0VED5LQDgp6xDurl
         p9n7lKf7BAl05bekR1Cq+tRIYaFY8o9jZUae7yl95tsapcKhcWkmoCCN/aqZKpEWD9dt
         PoBPBJlMGEyr4hQJy5Q6j/m9EqFNQp3PjMC0hU6L9g50zJPkOQHLfFJZCFohU3PwPpgt
         HAogy+0wZiAfPIoSSlUeGTREkv9qpkXJ+mdwTTVCkDOOW5wju8YP7YmyPZXPaloJx+cW
         Wq2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u/5ZAJi0CkaRF5CIqKAmErm1uNaTzftysAnpXOCQ4TE=;
        b=YQvDzm899m5EsHQFQheLxUnqZYEz8GiVeZ5rdTDasOP32GatTGna7bO/HKqiPhdpIt
         r9QWorMJSso2GiC0Q5Uo0Cl50WfBGra4xbhyi12/tICCpVRdeajvP2A460e2ORQqbB1V
         q0VMVpekYy3fkBwgJQn7uaArEm7nGKpU0pGndbAVZuXNwWy55jRBBY1NdQfCtNzJ+c/d
         CrGhJHJDyqqT1zNiudW/WaDvKBXBJ9sxpnDcA1IUgUJn+SeKNOdtctVPMFz3G7YSHMoJ
         pl1HzY8teXZ/48bCEoU4Aqpb2rvZtw9DZ6i7Jy7Yo7oraNv+bCkIAP+fbwntfWpmEduq
         ZugA==
X-Gm-Message-State: APjAAAXztPQUTmHQCEsaXkN+2Uf/L7DbBt2+Kn+lzZFAS8hfoCiSb8+5
        wt4eexF1XeI/dO6w+7jufv7akzED
X-Google-Smtp-Source: APXvYqxeHjtcq4foYX5DcFATVwXRg6fe0+qh5TltNfiFa9simogficKStnIOe3se0YRFvmQwqDEjVA==
X-Received: by 2002:a62:b616:: with SMTP id j22mr12829747pff.55.1570745996365;
        Thu, 10 Oct 2019 15:19:56 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 127sm8329205pfw.6.2019.10.10.15.19.55
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Oct 2019 15:19:55 -0700 (PDT)
Subject: Re: [PATCH 5.3 000/148] 5.3.6-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20191010083609.660878383@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <e72a6562-bc33-643a-ae28-705256fb5b3d@roeck-us.net>
Date:   Thu, 10 Oct 2019 15:19:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/19 1:34 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.6 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 12 Oct 2019 08:29:51 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
