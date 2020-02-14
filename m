Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB77515E322
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 17:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406620AbgBNQ1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 11:27:21 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39046 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406615AbgBNQ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Feb 2020 11:27:20 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so3912639plp.6;
        Fri, 14 Feb 2020 08:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qHYBxRU5tB9/qPsMy8ASzQpEWrMK6rQV8Tug1vzLMEE=;
        b=AxVonGNKidEoT2X4Mt5CLtHslWRUTl9VdgnEQOVUC4iomd/xeN75Lv2GPK53mc4cG1
         +YerF28T1uWJ/yL4nu9VSdxkTBrIMIwZXHswtmzNSbthu0tNIw6pSjxat9ER/IywPolq
         sYni6ORhBEHkwKh5aOoOX9iq/c5ZQ56OijnE7mda7QpNXXIrZVy3OF5SB39HQnP6FH62
         CzrtGCQta/xgXcaKx+AVwV0Hf/SL9jcqdXxl579x2t/C0WETFRZ3i08QuWA0irZvg1xV
         vjDplbYlgc1HC82QXAv/U760CbyjjLMebmjepRW/RKAcJ89sdI78Kt9FfMJHTnD728yf
         YvIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=qHYBxRU5tB9/qPsMy8ASzQpEWrMK6rQV8Tug1vzLMEE=;
        b=qWX9gwTssi7MUclypVVaGK2CihqTkvfyc1sA1lJTJhdUtuO+E4dTVvdNr96y8YDIv0
         K2uuLWfM6FWeqnv9siJ4icv8NAfk5bzNnG6oQ9mfSO91KldlaRS2HAu9/3z2fd3lCEnU
         Cu0o1vXYTbbQZSnpF5i3vy4sNFf0xO41SbexeOkFVE0l+r33zvCANfpdr8TLO4b04TWn
         HB1aZzEORu/nNeA63nYSVOviGBedT+UOn1WLB3TgnCghRsaIIKlturWe1nbag6juShhl
         1g2ySUEdyjLAj/UW0pW9kKZO/RYZ3yK23IIdOkvtk6k8y4NjJe2l/ESb1RYF96U9V1Ha
         BPGA==
X-Gm-Message-State: APjAAAVHMRCux3gAKOrqNmyMtvyhQMPoDOY9XnM6bkZpp+b3UGOIjSm+
        IZyPLKoSxkO1qxAR78H7LBA=
X-Google-Smtp-Source: APXvYqyJe8ThA7De3Z1+PG7+huE8be4e8hOsyuUejPe0JlDZRP1OQzdVvZ5JqS4HyhKCUvb8pCRmgw==
X-Received: by 2002:a17:902:a416:: with SMTP id p22mr4132433plq.107.1581697639435;
        Fri, 14 Feb 2020 08:27:19 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b42sm7094493pjc.27.2020.02.14.08.27.18
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 14 Feb 2020 08:27:18 -0800 (PST)
Date:   Fri, 14 Feb 2020 08:27:17 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/52] 4.19.104-stable review
Message-ID: <20200214162717.GB18488@roeck-us.net>
References: <20200213151810.331796857@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 07:20:41AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.104 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Feb 2020 15:16:41 +0000.
> Anything received after that time might be too late.
> 

For v4.19.103-54-g504347304f1a:

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
