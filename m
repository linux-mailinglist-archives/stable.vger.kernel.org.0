Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 188B744CD1
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 22:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbfFMUDL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 16:03:11 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39642 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfFMUDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Jun 2019 16:03:11 -0400
Received: by mail-pg1-f193.google.com with SMTP id 196so122298pgc.6;
        Thu, 13 Jun 2019 13:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=BuYlplQ4FbZtdPzQ9jho0PBZ//QfyRL330wA6Uj+cqQ=;
        b=uo7LFr+JMBCZA8SLGkPGKDigZ8bT/0wcx021t7dGz5xxWq+swV5eexBfQpSvF9Vpt9
         hodWofbY/wfpVfkcMRSH+MmHy1TUglZHvwvbUz1l3grgGf3xWF3X7+VOPM0xrzJNooKg
         nQmo6hquPMpeNyZqvqo/gixw8iFvRT4lOEIayTj8OqTUEnfR0y3HgMUlNUEXs2aRRjmP
         zGeF7RNAhzTm5JTQbIq2kXmVEtfEWCwDoKIONiw3KddNQjSmujNGWFb1kyKCpp6BjOcG
         ACgnmlGodGfB58oLtFd52UKXLHTXsSPv7nulrNd5lCs2mVNEi2epyku1SxVj5HJFDt7z
         Id6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BuYlplQ4FbZtdPzQ9jho0PBZ//QfyRL330wA6Uj+cqQ=;
        b=PkNqnASOx/JpTkB+ZogyQC7i+V/BNsbzJm1mmOmNPDMc9AbiadSdNTwaWfhGMSSh3y
         LrsNfahhpNzO4KeJAY328XSMkKM0I5yqHHun9+ue8UtQGYOps7s6HAHnaQlNdOKPwuQ1
         SjKGTGp8nszWrQFvR9xeq6blJX79pRtfvrmJo8Z/2jfwFoEnhyntxlrv2m4/UL59AMDn
         wPvf8kiJp5EEH/iSow1nasTUOG/t22DpaP95eSm0afMY5hOynHt14/9yNiZhDPIXEhEI
         gI6qVmqIafMsqbMMcAgreNShWVhk2eVxrHWDRZnjgTJoMxThhCw4jo/gMLopGvC9jywx
         4alA==
X-Gm-Message-State: APjAAAUjKbXOVHwOMNcrD5rYHWKdKq3H9Icfe/awMXsoccggECgDb4Kw
        cn2TEPyFakPDQ6Bu+5hwJq3ExzQc
X-Google-Smtp-Source: APXvYqwVUNBcLuKbK5vUOaPwB/klTr51gU1+/l1UZIf1802rj2NZZOufWreffgswA9YNAiiELDbcdQ==
X-Received: by 2002:aa7:8dd1:: with SMTP id j17mr4882093pfr.52.1560456190201;
        Thu, 13 Jun 2019 13:03:10 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id e127sm491153pfe.98.2019.06.13.13.03.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 13 Jun 2019 13:03:09 -0700 (PDT)
Subject: Re: [PATCH 5.1 000/155] 5.1.10-stable review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20190613075652.691765927@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Message-ID: <1526e84e-a087-452c-7f00-ff7f70de0cf4@roeck-us.net>
Date:   Thu, 13 Jun 2019 13:03:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/13/19 1:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.1.10 release.
> There are 155 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat 15 Jun 2019 07:54:40 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 354 pass: 354 fail: 0

Guenter
