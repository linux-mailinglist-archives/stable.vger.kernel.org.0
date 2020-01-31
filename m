Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A336F14F151
	for <lists+stable@lfdr.de>; Fri, 31 Jan 2020 18:32:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726139AbgAaRcI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Jan 2020 12:32:08 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36851 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbgAaRcI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Jan 2020 12:32:08 -0500
Received: by mail-pg1-f196.google.com with SMTP id k3so3827571pgc.3;
        Fri, 31 Jan 2020 09:32:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=didRMbxSKibSVbvqPj47ChO8FwXnSV6LD3tOEIOARYY=;
        b=Nm/u13jt8mcKGqrzfHyO9YC4mrOG02nX/vR9MQeAzp7gYt6arIjJXpDe2oPmfVw2zZ
         bkKElOkvhoy/gMJhgIF7Kd/tV7JsdxrA6sW3CPfQrS4m7DfNPWadc0xgCTUtRogyuBG/
         Rz7ww6hq4z2fkYTO9Kb/u9DUuNBfhR4In8ZByx/hOGmWE6U7HGXAtx9vvlEOpzu9BIDy
         sqKtD/uRg6nuYRb1DZLH+h88ypP1wX1xVnVHsxPIPB8nxuQTZH3VM8qjZcScCTkBD7Lc
         e089TuL+uDJWY/riqvOVxRVL64GU2gcGiVat3q6Mk3d2A6TxG8QAGFSrZ+LTXDq5yJaK
         OKaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=didRMbxSKibSVbvqPj47ChO8FwXnSV6LD3tOEIOARYY=;
        b=KuQw3E7zjJHapGYTIx2F/VESmml2ZwLDsCOkrDwlJKPXWiZ3VhyICNnauiWEIjDR6P
         HGDYUbu9qKuY5HbTJV7VXwanBD0hW9X/F+sshib6c3iTVjNxuItlMHTXZ8WtcP4BCLWI
         keSqAxUGwlF4thr5K4L2+P0c3LRb4e8kc0y6LE+fQ9i9RQVwJ7X7wySCxpTpemyN++p2
         42WhAV04xmEL8PNugAuCHSAP6rjYwn+e1L+ibqFQl8tIDec6qarYwVJ7boUasWWrpIMA
         jlEsMLlBW/OUSgIlngvcrFupdWehPz3Ke3BhMZe4DwXPK9Ubb1Lz2nj82jtaqd1QMIU6
         blMA==
X-Gm-Message-State: APjAAAX6mmpzfe3GFDmNUejlG89UeJlKlFla+Crlxw75JJvbDo+nTYhC
        ibwfL9Ai35N3fF87bWlJe4U=
X-Google-Smtp-Source: APXvYqx8Ekty6OpztYcdBKZrbpwIaTivBBFCGd8T46/8eF5mBO4lqF/p0Aj4zLS/O42lInPGMrjeNw==
X-Received: by 2002:a62:be0a:: with SMTP id l10mr12139630pff.110.1580491927361;
        Fri, 31 Jan 2020 09:32:07 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y190sm11357750pfb.82.2020.01.31.09.32.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 31 Jan 2020 09:32:05 -0800 (PST)
Date:   Fri, 31 Jan 2020 09:32:04 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/55] 4.19.101-stable review
Message-ID: <20200131173204.GA16567@roeck-us.net>
References: <20200130183608.563083888@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130183608.563083888@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 07:38:41PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.101 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2020 18:35:06 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 382 pass: 382 fail: 0

Guenter
