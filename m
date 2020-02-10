Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 973B915852D
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 22:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727363AbgBJVoa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 16:44:30 -0500
Received: from mail-pg1-f176.google.com ([209.85.215.176]:34519 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727003AbgBJVo3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Feb 2020 16:44:29 -0500
Received: by mail-pg1-f176.google.com with SMTP id j4so4602515pgi.1
        for <stable@vger.kernel.org>; Mon, 10 Feb 2020 13:44:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=JRP1HED7tO+yWGn5eY7FYK2UisIM4mw4FnQ6uxgZg80=;
        b=E9tjkHUHwmnHYoowmyy7pSI10npW68m+oA59ojqAqqvqrcWtRG7r5NHrqZKEpnd06e
         p2oqB87fiuqRZKNSb177+DTKL/FPdNZTjCfdHsHbjEZAeMBzK96neFUOob1EQpBw7tUZ
         Yyh827+zQjsmRJtfx4DulI5eQLnT3VIYaCrXhZJVecpxTQOx/o8qu0FJyElCuAzNAfgr
         ct9LZbAPRGzvyb4Aqoel4SBejriVuW3N0FhumCsC5WeyDpXtDuM92BuuTwF0dAbMRN7r
         YeJT7AwEP3okqWvIOM1hTL1SnV5MzhxyE9GcrtP9RBI2XUsQa1KlFOyPxYlp2JsiFgxv
         i76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=JRP1HED7tO+yWGn5eY7FYK2UisIM4mw4FnQ6uxgZg80=;
        b=TAEmZ3p/JYIyWgkKHP3DynohHIL8cKam0GpFfZ6U4lEsf+X4f1r54CyVgRh/YhuV2m
         jKT+9/YWcT6X5tS2rRnxRSAhhMIJ3E/QCKeopmxTWaFMANnyj+QC72+T5uQIWmEtMgN8
         wKpbt06YAeElw+VNH8ujkn2SwYTjwI55RNC/VX5yh1mVEocJxE0DHm2ZBl43NyqsHx9R
         b9jP2saXj/EWPD853VEIq7aMqIA+Enw0873dj+acONk9Tz6MGJaHUpq2BOZyzqIivFpN
         Au8+G92JEi1mZ2+QvrKK3XOqzztIM/WOjGcozT+WaW9kOMnW+swkNNS+ySFo/9ISBTJB
         4hRA==
X-Gm-Message-State: APjAAAUjuVBzX9MxObW7N80iEQ6OLU84EpsbzDredW9fi5754AorbEDT
        RC6RlTZwbjFQ1odNREpJqnLxAV+N
X-Google-Smtp-Source: APXvYqxgVXVnLudZ0FbXfujmDk6EU5VNS2g3UtA6AKysGSPI1gkg1E4p61XPewbdugaZZQIRVXALcQ==
X-Received: by 2002:a62:1cd6:: with SMTP id c205mr3022205pfc.179.1581371068951;
        Mon, 10 Feb 2020 13:44:28 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n2sm1417338pfq.50.2020.02.10.13.44.28
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 10 Feb 2020 13:44:28 -0800 (PST)
Date:   Mon, 10 Feb 2020 13:44:27 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: v4.4.y.queue build failures
Message-ID: <20200210214427.GD26242@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just in case this hasn't been reported yet.

drivers/clk/tegra/clk-tegra-periph.c:523:65: error: 'CLK_IS_CRITICAL' undeclared here (not in a function)
  523 |  GATE("fuse", "clk_m", 39, TEGRA_PERIPH_ON_APB, tegra_clk_fuse, CLK_IS_CRITICAL),
      |                                                                 ^~~~~~~~~~~~~~~

The problem affects arm and arm64 builds.

Guenter
