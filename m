Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96840145C23
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 20:00:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728665AbgAVS7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 13:59:41 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:35585 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725884AbgAVS7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 13:59:41 -0500
Received: by mail-pj1-f68.google.com with SMTP id s7so338342pjc.0;
        Wed, 22 Jan 2020 10:59:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=OCiyHCwGVX6cXc+IqNriDTFFc5ZzfNnMp//uWDfbbEQ=;
        b=FFmUvoVwpMI1eMlwg6b7ICsbfgwkOWK6kMxsJgTCQkHbIJfo67ptJdQLm7Jt10E+1D
         tikcSK0ocd6neilyevtlAhdQ18enuhTYjePXEALp/8jYECDGmfysOKaGnOQ9ePi6UkT9
         hIXQ7e9779N0uhTUpX2LDr9sHAoW8TKlBdW1G0qfcABlR7tSghhK3PDXXvReKRbEKB6W
         cvcRPBssQZRqh4EIogtq0Jh/MzioMwAuJphLJzpxaez1rPeNn4B0Rgp3xNFSJ27devWY
         hvyAwT3wfkYx0DQP4f0uegdqhhJiS/Q8s0eS2S7zsNex7Btry0Z+ErSsh/oY6FG6dqoz
         RwgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=OCiyHCwGVX6cXc+IqNriDTFFc5ZzfNnMp//uWDfbbEQ=;
        b=nAsLxh1hek3nDkSrBdobJQ55sUvjMgj6En3+pBn/W1/WVXlArF7OMIrab0E7oQdoVG
         Cd/bGiv1OUNkXo5ZHF9be1tHfIZ2wAritD1qZJ+Y4sCqJeoqDsQ/EffZyGXcQynQEHvr
         4ZVJCiILWw/LgHwiAIpB/iSXJWiUi5G7DSBpEQVG1+9jLcNWIxkC1eQfopGpErgyeTn4
         lJ6WcbxEPpO6PQAv+hDW/8lo3tBnGWugDdi1whq/OgAl2PHuW0dv8MBDw3bI/VglMsHJ
         hKnmWQfHhnaU7GBbIgxbmC2dntLFk5GV25WNj4XCx28xFYIgxYKhWlxkbVCUhvCzzr57
         +Ncw==
X-Gm-Message-State: APjAAAU7+YTnkF+vr1fxnbXSflpVhR7bSMj2zJojp9wWpF1DjLAJyRbQ
        8FWm9aODAy/0/eI1NEocRcY9nvZe
X-Google-Smtp-Source: APXvYqyp+Uj9cg5sM7g40DPIqbjnTUvuArs1fc3CN3++pHZeYScz4YS7lzC/pcEFdBy//aGkCzbacA==
X-Received: by 2002:a17:90a:d995:: with SMTP id d21mr4734424pjv.118.1579719580577;
        Wed, 22 Jan 2020 10:59:40 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v13sm50653000pgc.54.2020.01.22.10.59.39
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 22 Jan 2020 10:59:40 -0800 (PST)
Date:   Wed, 22 Jan 2020 10:59:39 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/97] 4.9.211-stable review
Message-ID: <20200122185939.GB20093@roeck-us.net>
References: <20200122092755.678349497@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200122092755.678349497@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 22, 2020 at 10:28:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.211 release.
> There are 97 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 24 Jan 2020 09:25:24 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 358 pass: 358 fail: 0

Guenter
