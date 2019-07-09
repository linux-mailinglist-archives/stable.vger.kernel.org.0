Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A39F63B3E
	for <lists+stable@lfdr.de>; Tue,  9 Jul 2019 20:40:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbfGISkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jul 2019 14:40:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46787 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbfGISkv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jul 2019 14:40:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id c2so8959808plz.13;
        Tue, 09 Jul 2019 11:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=r5rDK71XWscMn1oNPuapvmgB59JToguqPL3GDl1cLlY=;
        b=bFkVmif1fqBs+lTwEumGgLe28fP/vzIf+cS4HWD8msXxTNkbcUbYUclnEMjDP5yn97
         0Ua1cdywTmJ9BcZX8XW9OHxs7xZZijsmxU06XBIbC7tWsn6s8nHB8zKwhMpZf7IZLI5Z
         pwdi2Giv/TgYFupLTIS8oh3PAl7Y5qevzvhKX6h8finJVcw4G1YDXr9bTMhpWet7ke8P
         rJ/7f4LPWJd//mUisr0l5eKKehXcu8odjWDbgqaO1xtSq9e3VnfW9bvX4duF3PMuUA8z
         om+mKdKzyu6I5oLEanvJPwuUm/m/KWGTA4UDiDidJ/HPs4d+HHZljxvIMFivu4a5PfFp
         l65w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=r5rDK71XWscMn1oNPuapvmgB59JToguqPL3GDl1cLlY=;
        b=rnONjkO8LrNvStJrthiGlOePzOVAXmpH+TgdHMb0SkWBQymkNgw6/VVTLkVyGpJgOM
         GPXH+brhsSl7RCxI+ldCcvS/Vu70OHp7UcbQ8JtQMW6kHmOW0OLig2c7TAaEQkb4uRvj
         8q92aDnEjMjVF1NXWNg6Hwv1fyyCwGq5vA3NxyTE1ynW66Hr3t4MXvecErwWcOt+4+yg
         iS6AfXrTuN/NkMRdQwff8UWYute4MhWqgPJvLhqsC5wrvlmqIgProxxhBbh1pcnocn4R
         Bw3HM5w1YXgCYoMIkcWnXHNC+9hnRdLYDzKL1LnOWcaxD8JTfPzqxICWdNazPXtKhf9k
         TEZA==
X-Gm-Message-State: APjAAAUV/T7kGbwwvxDQls02WadUjFKvTihwxqCVAcfT5jolY6jzoD+6
        1MuWxzkYyPbi4onuOtucUBc=
X-Google-Smtp-Source: APXvYqxD7/+vhEeaoia6CjVRqzyXtQKTseTX4KV0BEpkrgE9X4xtcNx2zCloiDY8nelF5rL+69epgg==
X-Received: by 2002:a17:902:306:: with SMTP id 6mr34319588pld.148.1562697650385;
        Tue, 09 Jul 2019 11:40:50 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 14sm45553226pfj.36.2019.07.09.11.40.49
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 09 Jul 2019 11:40:49 -0700 (PDT)
Date:   Tue, 9 Jul 2019 11:40:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/73] 4.4.185-stable review
Message-ID: <20190709184048.GA2656@roeck-us.net>
References: <20190708150513.136580595@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190708150513.136580595@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 08, 2019 at 05:12:10PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.185 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 10 Jul 2019 03:03:52 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 307 pass: 307 fail: 0

Guenter
