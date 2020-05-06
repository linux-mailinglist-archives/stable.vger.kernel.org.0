Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8693A1C6554
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 03:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbgEFBG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 21:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729247AbgEFBG0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 May 2020 21:06:26 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44943C061A0F
        for <stable@vger.kernel.org>; Tue,  5 May 2020 18:06:26 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r4so347464pgg.4
        for <stable@vger.kernel.org>; Tue, 05 May 2020 18:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:to:cc:from:subject:autocrypt:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=dC3CN2E6Efv3q+lLzWzFSYOgB/jx4Ea8aXjyqrpjB3M=;
        b=D6KLRjCA6CAWLN+mLlMk2pCfRtsuuRFaQd7AOzCijr2dTP3G8LV+Th09QTPSu4NC9q
         Erv7giIOC6duv6CUtKuz9Z2hv4QUTd96y1G7kcoSGPxDBSosZiLjUfQDUOwdw5EobAnb
         /t/kBnbucrm6vBk89Q4vJd13g6hG9n6ffZ2cK19pxL6/At60CuLAur2Z4tKhZ1ULd0IK
         n1+GkNhMNiW09HLsh0ONJA5H4Aw+pGVk5zdUFvtpZ8c6fPLAaC+waJwIirJgwPgMk5zw
         A6VPr7/+1YmKuY4pCsCTsWy8laUQdys+EYnGLYOcyyDB4OwPTcbG92fVJlYcFyR8uLBF
         jGsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:to:cc:from:subject:autocrypt:message-id
         :date:user-agent:mime-version:content-language
         :content-transfer-encoding;
        bh=dC3CN2E6Efv3q+lLzWzFSYOgB/jx4Ea8aXjyqrpjB3M=;
        b=S0UsOnSB7VqfCqUcfJkJqtIhhllQkh2QAENvVCmOqKlNeQTte3L7Suu9PGnDu72c9x
         6XTVWWSB5alHEJlZA/WWXtILY0VcaqLfQk/VZO1mv7qmuXx0ekaOWvtJOL7jYiUJEpnf
         bRCmWTd+C3c89mwPVF7sIZRcHx1J+5PdCpaC0o7ZP9R6KveUG5krBH1k7LhgO4f7Lu4V
         oAN6JnAt0Mh9a+Q+Ujiq/ZvuAi9HNTJCOFW5T3XBYVzsjRAodmYkMpHdEQ3UEsEzIaLe
         domoj/nfyA2LfGlpBWzMRKy5xHjXrYB3on2+OAcvvYOCD0Hajpz0ewi09A0Nbfz70Noe
         ikvw==
X-Gm-Message-State: AGi0PubM5Ip9ZLqjFaCvuaxlZrUteLXOR1sQh5LhbZKgFJIszZl8u0wn
        9suxWpz4MQd9fmxoabDTp4g=
X-Google-Smtp-Source: APiQypIOYX/vgXVLKUsh2VKEwjsYcVZnO894s8YWFrp1U0YJsSFrue4XTH3l3CLSEU1Lczh7DAi3BQ==
X-Received: by 2002:a63:4665:: with SMTP id v37mr4782830pgk.297.1588727185659;
        Tue, 05 May 2020 18:06:25 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i8sm64959pfq.126.2020.05.05.18.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 May 2020 18:06:24 -0700 (PDT)
To:     stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Please apply commit dead1c845dbe ("powerpc/pci/of: Parse unassigned
 resources") to v4.19.y and older
Autocrypt: addr=linux@roeck-us.net; keydata=
 xsFNBE6H1WcBEACu6jIcw5kZ5dGeJ7E7B2uweQR/4FGxH10/H1O1+ApmcQ9i87XdZQiB9cpN
 RYHA7RCEK2dh6dDccykQk3bC90xXMPg+O3R+C/SkwcnUak1UZaeK/SwQbq/t0tkMzYDRxfJ7
 nyFiKxUehbNF3r9qlJgPqONwX5vJy4/GvDHdddSCxV41P/ejsZ8PykxyJs98UWhF54tGRWFl
 7i1xvaDB9lN5WTLRKSO7wICuLiSz5WZHXMkyF4d+/O5ll7yz/o/JxK5vO/sduYDIlFTvBZDh
 gzaEtNf5tQjsjG4io8E0Yq0ViobLkS2RTNZT8ICq/Jmvl0SpbHRvYwa2DhNsK0YjHFQBB0FX
 IdhdUEzNefcNcYvqigJpdICoP2e4yJSyflHFO4dr0OrdnGLe1Zi/8Xo/2+M1dSSEt196rXaC
 kwu2KgIgmkRBb3cp2vIBBIIowU8W3qC1+w+RdMUrZxKGWJ3juwcgveJlzMpMZNyM1jobSXZ0
 VHGMNJ3MwXlrEFPXaYJgibcg6brM6wGfX/LBvc/haWw4yO24lT5eitm4UBdIy9pKkKmHHh7s
 jfZJkB5fWKVdoCv/omy6UyH6ykLOPFugl+hVL2Prf8xrXuZe1CMS7ID9Lc8FaL1ROIN/W8Vk
 BIsJMaWOhks//7d92Uf3EArDlDShwR2+D+AMon8NULuLBHiEUQARAQABzTJHdWVudGVyIFJv
 ZWNrIChMaW51eCBhY2NvdW50KSA8bGludXhAcm9lY2stdXMubmV0PsLBgQQTAQIAKwIbAwYL
 CQgHAwIGFQgCCQoLBBYCAwECHgECF4ACGQEFAlVcphcFCRmg06EACgkQyx8mb86fmYFg0RAA
 nzXJzuPkLJaOmSIzPAqqnutACchT/meCOgMEpS5oLf6xn5ySZkl23OxuhpMZTVX+49c9pvBx
 hpvl5bCWFu5qC1jC2eWRYU+aZZE4sxMaAGeWenQJsiG9lP8wkfCJP3ockNu0ZXXAXwIbY1O1
 c+l11zQkZw89zNgWgKobKzrDMBFOYtAh0pAInZ9TSn7oA4Ctejouo5wUugmk8MrDtUVXmEA9
 7f9fgKYSwl/H7dfKKsS1bDOpyJlqhEAH94BHJdK/b1tzwJCFAXFhMlmlbYEk8kWjcxQgDWMu
 GAthQzSuAyhqyZwFcOlMCNbAcTSQawSo3B9yM9mHJne5RrAbVz4TWLnEaX8gA5xK3uCNCeyI
 sqYuzA4OzcMwnnTASvzsGZoYHTFP3DQwf2nzxD6yBGCfwNGIYfS0i8YN8XcBgEcDFMWpOQhT
 Pu3HeztMnF3HXrc0t7e5rDW9zCh3k2PA6D2NV4fews9KDFhLlTfCVzf0PS1dRVVWM+4jVl6l
 HRIAgWp+2/f8dx5vPc4Ycp4IsZN0l1h9uT7qm1KTwz+sSl1zOqKD/BpfGNZfLRRxrXthvvY8
 BltcuZ4+PGFTcRkMytUbMDFMF9Cjd2W9dXD35PEtvj8wnEyzIos8bbgtLrGTv/SYhmPpahJA
 l8hPhYvmAvpOmusUUyB30StsHIU2LLccUPPOwU0ETofVZwEQALlLbQeBDTDbwQYrj0gbx3bq
 7kpKABxN2MqeuqGr02DpS9883d/t7ontxasXoEz2GTioevvRmllJlPQERVxM8gQoNg22twF7
 pB/zsrIjxkE9heE4wYfN1AyzT+AxgYN6f8hVQ7Nrc9XgZZe+8IkuW/Nf64KzNJXnSH4u6nJM
 J2+Dt274YoFcXR1nG76Q259mKwzbCukKbd6piL+VsT/qBrLhZe9Ivbjq5WMdkQKnP7gYKCAi
 pNVJC4enWfivZsYupMd9qn7Uv/oCZDYoBTdMSBUblaLMwlcjnPpOYK5rfHvC4opxl+P/Vzyz
 6WC2TLkPtKvYvXmdsI6rnEI4Uucg0Au/Ulg7aqqKhzGPIbVaL+U0Wk82nz6hz+WP2ggTrY1w
 ZlPlRt8WM9w6WfLf2j+PuGklj37m+KvaOEfLsF1v464dSpy1tQVHhhp8LFTxh/6RWkRIR2uF
 I4v3Xu/k5D0LhaZHpQ4C+xKsQxpTGuYh2tnRaRL14YMW1dlI3HfeB2gj7Yc8XdHh9vkpPyuT
 nY/ZsFbnvBtiw7GchKKri2gDhRb2QNNDyBnQn5mRFw7CyuFclAksOdV/sdpQnYlYcRQWOUGY
 HhQ5eqTRZjm9z+qQe/T0HQpmiPTqQcIaG/edgKVTUjITfA7AJMKLQHgp04Vylb+G6jocnQQX
 JqvvP09whbqrABEBAAHCwWUEGAECAA8CGwwFAlVcpi8FCRmg08MACgkQyx8mb86fmYHNRQ/+
 J0OZsBYP4leJvQF8lx9zif+v4ZY/6C9tTcUv/KNAE5leyrD4IKbnV4PnbrVhjq861it/zRQW
 cFpWQszZyWRwNPWUUz7ejmm9lAwPbr8xWT4qMSA43VKQ7ZCeTQJ4TC8kjqtcbw41SjkjrcTG
 wF52zFO4bOWyovVAPncvV9eGA/vtnd3xEZXQiSt91kBSqK28yjxAqK/c3G6i7IX2rg6pzgqh
 hiH3/1qM2M/LSuqAv0Rwrt/k+pZXE+B4Ud42hwmMr0TfhNxG+X7YKvjKC+SjPjqp0CaztQ0H
 nsDLSLElVROxCd9m8CAUuHplgmR3seYCOrT4jriMFBtKNPtj2EE4DNV4s7k0Zy+6iRQ8G8ng
 QjsSqYJx8iAR8JRB7Gm2rQOMv8lSRdjva++GT0VLXtHULdlzg8VjDnFZ3lfz5PWEOeIMk7Rj
 trjv82EZtrhLuLjHRCaG50OOm0hwPSk1J64R8O3HjSLdertmw7eyAYOo4RuWJguYMg5DRnBk
 WkRwrSuCn7UG+qVWZeKEsFKFOkynOs3pVbcbq1pxbhk3TRWCGRU5JolI4ohy/7JV1TVbjiDI
 HP/aVnm6NC8of26P40Pg8EdAhajZnHHjA7FrJXsy3cyIGqvg9os4rNkUWmrCfLLsZDHD8FnU
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <27f9b53a-d24f-538b-d7cb-f2d79e096ba7@roeck-us.net>
Date:   Tue, 5 May 2020 18:06:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please consider applying commit dead1c845dbe ("powerpc/pci/of: Parse unassigned resources")
to v4.19.y and older stable branches.

When testing qemu v5.0 in my build system, I noticed that I can no longer boot pseries
images from sdhci/mmc with v4.19.y and older kernels. When tracking this down, I found
that the devicetree structure passed to the kernel has changed in qemu v5.0. Specifically,
there is no assigned-addresses property anymore, and the devicetree structure looks
more like a generic devicetree structure.
As it turns out, that change has been addressed in the Linux kernel with commit
dead1c845dbe ("powerpc/pci/of: Parse unassigned resources"). After applying this commit
to v3.16.y..v4.19.y, the problem is fixed.

I could work around the problem by using qemu 4.2 for older kernel branches, but
I would prefer to run a single qemu version for all branches if possible.

Thanks,
Guenter
