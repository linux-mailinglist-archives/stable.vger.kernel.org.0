Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E697951B5
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 01:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728704AbfHSXiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Aug 2019 19:38:12 -0400
Received: from mail-pl1-f170.google.com ([209.85.214.170]:33565 "EHLO
        mail-pl1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728608AbfHSXiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Aug 2019 19:38:12 -0400
Received: by mail-pl1-f170.google.com with SMTP id go14so1723134plb.0
        for <stable@vger.kernel.org>; Mon, 19 Aug 2019 16:38:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=8ZuAh+VP9iQjOCjsn0hhsacefIalhi/VcyDbi2eWsVQ=;
        b=tG45G1sKcEQhQTMc+uPzfIi/BPEz6VnSVvwIUPsnZVGPzflh36wMB1DeW2+aFyohDW
         RXezMNqxjdO1zIC1JDkFikLYMFLy7Ijn0LtFZGbONkPoIK8AyFLf8jOSniCdQLjn8EDo
         l7kF2tPL95W6EA8tLpo4el2ZYQeNrgl7ku5HEwHaCj6kQDFXCVwC0pHnGtR3gfZsiubz
         jU9qlQknhMtQgwQcqL9VCL2c43vmf0fmg5KZuVdj97EJpXPT2KXJCI+DNEqw16rbg5yS
         QEdOAM3gzWL2rPbP47qbyZfe0g1IatEs195lIeQJtDw3W1PsxPuaK3U+0vSPHFTtgMXC
         v4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :mime-version:content-disposition:user-agent;
        bh=8ZuAh+VP9iQjOCjsn0hhsacefIalhi/VcyDbi2eWsVQ=;
        b=ueE4bzcrfBVYAtUHADyMXI/4AQ3gi4wB7Z9Zzb6NUXCcQgGPsy+R4JkYejBHEPuwUG
         UQNA6R+agk+HkZA11Ws4xg5V30zH4RTFXfA9pMrMUxl5lofWmVCLxKrnpjC6PrnQi0NH
         7WU+0IexdffvyhYX4kKYPDbFmJQh6m7gqLjinfnnlfhtEJiomajNa8IN1Sr0Dd+CYGIK
         yL4USxm9WoCaD9A1mqU1gzrtftRvlpdTorNFkEZnTP84bl+c3SbuGyGdqqw3wrVmVLOz
         whPhTQl8jt4Gh2daTIS3f2hWeGv+h9dZUIG2/9Ho3GiuGYbPCvEVIOqQFb7KUE2Y08+Y
         u9zQ==
X-Gm-Message-State: APjAAAXOb/K34MuXvJmsCNQAmqPXgsovd+WiUW1Sw45euV6L+KmRSKWy
        Yw9hkrDw2QsWfmjfop+XiVw+9yVD
X-Google-Smtp-Source: APXvYqzm1eTVSnqLQmjQ0qxbjVYHzxkjl3sQ967czlfXXPck5O34EP4CgygnW5XD3eeTK6aLra9EbA==
X-Received: by 2002:a17:902:988d:: with SMTP id s13mr16680495plp.139.1566257891573;
        Mon, 19 Aug 2019 16:38:11 -0700 (PDT)
Received: from localhost (108-223-40-66.lightspeed.sntcca.sbcglobal.net. [108.223.40.66])
        by smtp.gmail.com with ESMTPSA id r23sm19140540pfg.10.2019.08.19.16.38.10
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 19 Aug 2019 16:38:10 -0700 (PDT)
Date:   Mon, 19 Aug 2019 16:38:09 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>
Subject: gcc 9.0 support in v4.4.y
Message-ID: <20190819233809.GA13230@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

please consider applying the following two patches from v4.9.y to v4.4.y.

fe5844365ec6 ("Backport minimal compiler_attributes.h to support GCC 9")
2c34c215c102 ("include/linux/module.h: copy __init/__exit attrs to init/cleanup_module")
	(upstream commit a6e60d84989f)

... to enable compiling v4.4.y with gcc 9.x.

This already works for the most part, but alpha:allmodconfig and
arm:allmodconfig fail to compile. The above two patches fix the problem.

Thanks,
Guenter
