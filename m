Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 338FC4F2D6
	for <lists+stable@lfdr.de>; Sat, 22 Jun 2019 02:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfFVAoR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 20:44:17 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45002 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfFVAoR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 20:44:17 -0400
Received: by mail-pg1-f193.google.com with SMTP id n2so4110983pgp.11;
        Fri, 21 Jun 2019 17:44:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=I9VXdafIT5ywBqwgKxqG9IsZhUAP4gd3GhGLalyk17w=;
        b=lPmbMBRQlWMkFK510xEwh6AEjCO8xOcuJ6A7mWSyLwAnU/d4mjy1EuSy5iOEFrpVJ5
         mtyMLAf+yhl30bTHEztwvHF20mGUKF7w4rpQ2eXHypV4LkfeEIoEB8YIxZUSo5SJrSSM
         sJVQMa1UEOTY59rl6uwPyPhbutbKVDdzkyyvW84Natccj0Co6USQ85VV5wBW5bg7sB4u
         /LkSVe0vDEIWd/YBjPkMKFfk99lB7lACPOZYGz82KlXqL16JEbCqcYzuB5DkW62+okl2
         7jutTyMQENu+offFVd1+adcUJKHOfJQGSOlf3aIXNMqGdz/EEyryfMR3bbQ6Yj7ajBzC
         J9uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=I9VXdafIT5ywBqwgKxqG9IsZhUAP4gd3GhGLalyk17w=;
        b=UW62fao/V4CMBO+xmKfPbk0+f83DX7ygm3CDMIjyNllxwwiKepDXqxRPID+sKkutjH
         Sxtl4bafhUFNZ+XvgXLLr5CKCTf8SN5dBDuKf2czs2dZwCnfhHcT9+Ig/d4CKjghM+Fv
         KkjSM4xkDU9ts0IT+AYxjWoG+Gvz3XIsocUUQmuIg8Nug8LtpUFvQK8PRqwq3RUCf+ON
         xeFzG1nl4kEaWMrc8E6RhHSmymmZYlarmOqu71UZx9bQbUnrxZpGZcUX8Ava8m+rb5UB
         TBNgkrsd/Ztz45To+ZxJnfi7qlPn+FM5xXVAUJOF41oD1hdJXmEGQm/7/gjV1bDDeIrO
         Mu0w==
X-Gm-Message-State: APjAAAXv52SAVQ564P6D0lkvfZZxwkTXfjaH4f03et3aqm+ROcspJSgb
        O5AwZFlGENv/4MHmKg/mXuxf44PN
X-Google-Smtp-Source: APXvYqyy0HFzJo6Csyhy8djRRVys8BXFBr00QHNsNUrCRQybfPOJGmPF71Syo5m0YhHJoy6XEsLSGA==
X-Received: by 2002:a63:1d5c:: with SMTP id d28mr10639717pgm.10.1561164256166;
        Fri, 21 Jun 2019 17:44:16 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d132sm5434608pfd.61.2019.06.21.17.44.14
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Jun 2019 17:44:15 -0700 (PDT)
Subject: Re: [PATCH 4.9 000/117] 4.9.183-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190620174351.964339809@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <ffe44a14-ca8b-e41d-3766-3851842adfde@roeck-us.net>
Date:   Fri, 21 Jun 2019 17:44:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190620174351.964339809@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/20/19 10:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.183 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 22 Jun 2019 05:42:15 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 333 pass: 333 fail: 0

Guenter
