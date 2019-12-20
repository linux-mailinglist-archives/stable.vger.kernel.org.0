Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD612826C
	for <lists+stable@lfdr.de>; Fri, 20 Dec 2019 19:49:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfLTStZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Dec 2019 13:49:25 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:40591 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727413AbfLTStZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Dec 2019 13:49:25 -0500
Received: by mail-pf1-f196.google.com with SMTP id q8so5684695pfh.7;
        Fri, 20 Dec 2019 10:49:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=SMckgnFpG3mlIZx4hS+BN/hFG8Yc9fABhWAW0v7fzKM=;
        b=T9Qt4mmCmrHU6tNZhTHI3VZoBI5NtnqR0PoYMvd/joURJHyt4Qk0E7Ymo/sK+TzCUN
         RWRme7Oa8H1pOsjP/+c7dxve0b3KuNFss51JZSkPLKN8MHEjvTgVabYhBl2QFDQOodan
         i1+89ekXFRiiDEx43Dq6/ESAQMX/YsgxNuV7ze0lO0BzHBZcImjD9FiBajDn7iaCa2iZ
         fa2j57oYwJXNHg9YpdrzpcKKMn+OAiymKDWzGvL93M0IGVxZVsDEtCIq9ll6fqoiJC00
         PGhJiJ6r8+ppGPp1uzGzgGbi01TLF92S4u3Iyako4G1I5BBrzi5yiM7uxu2nILHZWe8x
         tteA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=SMckgnFpG3mlIZx4hS+BN/hFG8Yc9fABhWAW0v7fzKM=;
        b=M4V10vt03QirzsJ+zpOVxlwXzRg4VZTSbPwnqtPRrc7CeiI14FAJV6tmDBQNKsg1EG
         qCtcCtzozvOzYWua+sLSnNkzW4XHowYqQzl0VF2wIpnkoIVsmHU0mM/tlh0JLj+psZ4D
         C2lQHwU9+4DH7YwNndUcDAxCpyjvftWNpx8A/Q60KtwQPQ9T45ViX1M1eQKhNxOwdqmf
         D/LsVAvdD1wJ6v2moDnw6Sj9R7cZM0SJzqsRpYERY1SBPoH83CTBvaePGqpPyDGlhPpD
         1+qj3dyrXId7d+skKbEo7QwszWYQjJZ4lsEnh82X+oiECtiyYRShjfVXO5dbH9M7UeFW
         SR2A==
X-Gm-Message-State: APjAAAUlbYolj0mhkpaPyy/MrENA41x5+uAOJhIqYFa6fhAxoiy8Tx8V
        PMje+mGazOj07ZiIqu2VBdA=
X-Google-Smtp-Source: APXvYqxmdma63x0dwR1PZZEeUZr42CHMH4ZFG2U/g/qQMgjIO4+WVCQKN1oHbZs9Uc4xzWcG3Ov5Pg==
X-Received: by 2002:a63:1c64:: with SMTP id c36mr14418928pgm.302.1576867764942;
        Fri, 20 Dec 2019 10:49:24 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c1sm14089504pfa.51.2019.12.20.10.49.24
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 20 Dec 2019 10:49:24 -0800 (PST)
Date:   Fri, 20 Dec 2019 10:49:23 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/47] 4.19.91-stable review
Message-ID: <20191220184923.GD26293@roeck-us.net>
References: <20191219182857.659088743@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191219182857.659088743@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 19, 2019 at 07:34:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.91 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 21 Dec 2019 18:24:44 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 383 pass: 383 fail: 0

Guenter
