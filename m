Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DED36134F9F
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 23:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgAHWw2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 17:52:28 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43961 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgAHWw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jan 2020 17:52:28 -0500
Received: by mail-pf1-f196.google.com with SMTP id x6so2336284pfo.10;
        Wed, 08 Jan 2020 14:52:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=g1kbrZtyZAAKENR54pIVneAHXym82XgJaiiw55EZyxw=;
        b=bzdMPK5ZLRATem1WVJvRTtwTYEFGFMbPbf8x1K6U4cb8NBww1lB8eETpD+Tpd9V8TW
         M3itPmabvr75bNvFrCMzpUcTPpQApnOjoT/bqIlo97J/YeUxsxSg+u7iJTzNHkmhBvFI
         ny5mAUS09mF/IBqz1aHES0L4I1a6MqRcwgfpWLEvFKlBry/9/GcbqL721lLAsE7h43Pg
         gba3DPTIibsaD+brnN+n5SRSYxwq4YI1AVjEGvGBVVOGwl8hpmGq34pHt5eZG5EzwwHi
         F0mJSQBsTUofNLXJn8MtBdlyOgP55S0cHR72UIrF1N/NbwZBCZ6PkaqX7vD5n3hG5QLB
         vocA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=g1kbrZtyZAAKENR54pIVneAHXym82XgJaiiw55EZyxw=;
        b=Kc8QXx+irxd0rmOD/VuJHkN8s0u8Cr3EYcO/LARexKHkJ22g1DhqF8qxISidKW9G9M
         G4WKlUjmsS0Ripl1mveGRlRHmVBif3Uy95oYX9K3WdXPDGDd+VJU/QvznGgI5dyIsPYa
         yW4KIN7QWve4IKlr9XW+gBnYjrYnPoivqDvamB2R3H6YARWAp93nkVCdD9MvcZ7ZE+zJ
         FiOp95VGozmSv0LguTf2jmDvrg2Xe5gm3CBSSSepc6SCHtq9ja+BgGMSYDV7TT4BBEvB
         Yjp3ZAj05IRivg0qFQCVAbjfh4tWPBYfjMTprEi7VMYv3AI0StBvztw1xZKmo8sKo5W3
         YaeQ==
X-Gm-Message-State: APjAAAViwfPsL+6uXv46YyiKhzfO4jyjD/wL6Y4EgvxK3tMfKMK/esdA
        7tJQNQVKmppNywAef/y21LE=
X-Google-Smtp-Source: APXvYqx7GQYBMlwJE0OVggvfIiah7GvE/In7ia4UeEJeHIxJW/jTB/XC/5ZF49OERZ74xR7F/bNmPA==
X-Received: by 2002:a63:5114:: with SMTP id f20mr7604127pgb.321.1578523947113;
        Wed, 08 Jan 2020 14:52:27 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j10sm318752pjb.14.2020.01.08.14.52.25
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 08 Jan 2020 14:52:26 -0800 (PST)
Date:   Wed, 8 Jan 2020 14:52:24 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        Denis Kirjanov <kda@linux-powerpc.org>
Subject: Re: [PATCH 3.16 00/63] 3.16.81-rc1 review
Message-ID: <20200108225224.GA29712@roeck-us.net>
References: <lsq.1578512578.117275639@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1578512578.117275639@decadent.org.uk>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 08, 2020 at 07:42:58PM +0000, Ben Hutchings wrote:
> This is the start of the stable review cycle for the 3.16.81 release.
> There are 63 patches in this series, which will be posted as responses
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri Jan 10 20:00:00 UTC 2020.
> Anything received after that time might be too late.
> 

Build results:
	total: 136 pass: 136 fail: 0
Qemu test results:
	total: 227 pass: 227 fail: 0

Guenter
