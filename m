Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8643248B55
	for <lists+stable@lfdr.de>; Tue, 18 Aug 2020 18:19:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726715AbgHRQTD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Aug 2020 12:19:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgHRQSz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Aug 2020 12:18:55 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBB20C061389
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 09:18:54 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id o5so9991606pgb.2
        for <stable@vger.kernel.org>; Tue, 18 Aug 2020 09:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ZT3ADvK8h5tCJHlHN7VQw4gwN56mqXQRK74MwcMWR4w=;
        b=ZxD4t4/tHgTYEAv1pDOxeOTofkiclzUehhtfyWqDIqD7TUhRmy5DNNK6eWE8/d0o8b
         63169Turqp6y1A7B9k25kHBBZ8qIEQ9jfA5K/1etm98vmB+TYq+ZUa7ODEcCV+B0fVPn
         MXJO93HpGop8yVuVE1V5LFw29Phy0Nm/c5b6693T6wQfVIv0b7KLlrxJNlcVC+saweeC
         GtVBgYyMy2uGI6mFC9rgp7qdCNwulrlPgmPXWJI04lbFYARrNjibXk7Hgkf5kqe2Ih7g
         bazRZMRRMDjPorQ8a2cT6+iZR9vwmxrBQb/8pXV/sqC6le4baIAnDVakvBSQbhMjM544
         a0dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=ZT3ADvK8h5tCJHlHN7VQw4gwN56mqXQRK74MwcMWR4w=;
        b=aB8GFDRgfpmUf/jUXkjMZzMd3a03GM6N5dqbOp0mvWhlL2WK9nKNAtiu+Nt9vEbAoi
         bOg9TRJ4ej8yje8kuKQOUzVU4OAUfY3FQVlgRGrWFgGvXfTMcJCVujhalcnLNtNoob+6
         FEWG1DucGw1BueHCOwt/mrqe/cgQOBp3g4+3u4dAxgJk4BGnT7EckWBg9NLi9QclTSqz
         LZ+0W3FrfqBDkFtexzruImUbz8+tX6t99HE/ae7zH1pi3hE0ASX2V6ntB5VoicmsiVG4
         T5ebabDZ0ecu0hlRulkTeXNXNnfsS3rNh5GiGQb2yJl1JvgHUs8wIMTjXm9dkNPrOWLK
         thWA==
X-Gm-Message-State: AOAM532BWPDJEHl5m2vKWGdvREri6aj7Z1TOk0S4VzjNOIemE5Xyn7aU
        lRdAQifX8KFYfnEyBF8ZQZY=
X-Google-Smtp-Source: ABdhPJwSxT9nKEmn3/FMP39d93CKDQpaLMxJ49TVKYWjwvK+yCg0Llw5+70jpJfRsTgfQFCqAoy65w==
X-Received: by 2002:a63:dd13:: with SMTP id t19mr13471186pgg.430.1597767533332;
        Tue, 18 Aug 2020 09:18:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x4sm25062731pff.112.2020.08.18.09.18.51
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 18 Aug 2020 09:18:52 -0700 (PDT)
Date:   Tue, 18 Aug 2020 09:18:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Build failure in v4.4.232-120-g11806ba5e43a (v4.4.y-queue)
Message-ID: <20200818161850.GA259221@roeck-us.net>
References: <463ae6ac-b8e4-c447-814e-89ef7bdf1078@roeck-us.net>
 <20200818151059.GA689005@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200818151059.GA689005@kroah.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 18, 2020 at 05:10:59PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Aug 18, 2020 at 08:01:48AM -0700, Guenter Roeck wrote:
> > Seen with v4.4.232-120-g11806ba5e43a:
> > 
> > Building powerpc:defconfig ... failed
> > drivers/misc/cxl/sysfs.c: In function ‘cxl_sysfs_afu_new_cr’:
> > drivers/misc/cxl/sysfs.c:558:1: error: label ‘err’ defined but not used [-Werror=unused-label]
> 
> Build warning stops the build?
> 
Some configurations enable -Werror, in this case with CONFIG_PPC_WERROR=y.

Guenter
