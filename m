Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7F43EC464
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 20:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238877AbhHNSQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 14:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238811AbhHNSQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 14:16:43 -0400
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BAD3C061764;
        Sat, 14 Aug 2021 11:16:15 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id v10-20020a9d604a0000b02904fa9613b53dso16019307otj.6;
        Sat, 14 Aug 2021 11:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ljiSF4CN2J2CBVmvFcY3AbenllWCLDSC0QqVs0K6Glg=;
        b=N0t4LQ/AqkFU3QYJ8X6/ndLbOk4qy6dPMK7vnPWjuxK6YKmfHRHjeGVjQShN8HAU05
         s73Lyy7J8Z4L59Hr+hgssTd8zAiX5nDhwpYkbjzTy/ube5SWC6dDB1fZmpGTMPL6stIG
         pJCLzJ1tD+ODCLHhWeDZR81emNbPYsxQmj9wHNo8hKowbagnl496DVHOxSBjQyrk4K92
         17BjBoCO4NEemBqVkZnK/0Rl/WhGTE3SQ5pcOrkVYV+87aRvssz5TQbslIGdT06WRVb9
         bhfEZPVrUGhqf9G7Kgb5c53Ggfk5NWwZF6yRKGV7XL1aP8IsXgBnxZiLaNSfcdzbe9Pn
         L/Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=ljiSF4CN2J2CBVmvFcY3AbenllWCLDSC0QqVs0K6Glg=;
        b=ZICLU5BcnBdnkOknc6rlccfVyPxNWzITD0MnqWa3sjvuSyZ1dqmbLs1/DP1iW6bcQi
         e8t2jpfd14DQGia79w3FmpHVUvPwPyuTWrXI857Jm05r0vcXo6m38fHgq+fPC5z2NvqR
         DTTUtI57CguAeBdmyoGt77OEFB/Jc/nkfoDgLXIiy3gxi4NECv20rvy9FRH2WRvEkOxH
         wP8LCsIR6Lt1gNS74AyPCpbOIam0kQEsK1+g49VO3TQJ0sjFaxqzSOZjO6qSiIkdnjHg
         vx2Rs5qq5TuwhWeB9/XQ0yAQb57deBL2evJYdBZvbfYHBD0HZN8olYYgQKL1G6o3Ix7Y
         zSOQ==
X-Gm-Message-State: AOAM531LWNsp/tQQovU4cd5aASbwJrnREadu7Vx0UXjMqhYG3PlgMWbi
        uofboJbp35TQzD0cyhk0Jh8=
X-Google-Smtp-Source: ABdhPJybnG+X0WJxYb+wTmEPZ0yXckqo68mv/IwoNDLSxlCceRoQDmGHQcN391g0bbYWCsIQ7v/G/A==
X-Received: by 2002:a9d:4105:: with SMTP id o5mr6657552ote.20.1628964974709;
        Sat, 14 Aug 2021 11:16:14 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h2sm1142221oti.24.2021.08.14.11.16.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 11:16:14 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 14 Aug 2021 11:16:13 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/19] 5.10.59-rc1 review
Message-ID: <20210814181613.GE2785521@roeck-us.net>
References: <20210813150522.623322501@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 13, 2021 at 05:07:17PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.59 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 472 pass: 472 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
