Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3756B23118E
	for <lists+stable@lfdr.de>; Tue, 28 Jul 2020 20:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732274AbgG1SX3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jul 2020 14:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728829AbgG1SX2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jul 2020 14:23:28 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62317C061794;
        Tue, 28 Jul 2020 11:23:28 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id o1so10360454plk.1;
        Tue, 28 Jul 2020 11:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YUQUF1CbHQoHlZAeTod2dmR3SujauGyd7iOHaTPi5JU=;
        b=d1RD3TegaARod+v3GTBo7mUPjo2FlBW4aC7T3P3zKKrJMT6n0q8O5BbykgYRmthYRd
         HNRPEfoDTiCTnaXkXC53SWrx6oFp0YNNjOwPNSmyvcjhlBYfZ5IGcHSZjTH2/RE00kVe
         Z87NODgPCT4W7+F50p7mxzq8/RRAQ13Ldfx6KjSMQlVJuU1cp9Xc6wB5E/TPVw+mqPdr
         Bp1CBgIB/SW8B5DHtGfX3RImPLaCzhnaA6h8ghQG+RvuJS6EmbA1cYcXcQ29n5tSu2Rj
         YUkOuW7frYk15WKgXakzOaYQdm6pICZ5JzF+zrqTdpsIUqmXDhvJ8c8mWNVo1ugMiHcM
         KC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=YUQUF1CbHQoHlZAeTod2dmR3SujauGyd7iOHaTPi5JU=;
        b=FOAuJo3GHMrADVO0UcpX8071/XkStINW4O6zuSoY8ULbEel+UxxIKy8etg4FrvPxJ1
         WgYDFWuFE5NmrAf0rcVus3jzcF5K53RtFbuZapSICV7UESd/CACWcYm+Fk7VvEJSx0d/
         K+YOGywE5Er6JZs0z4cpVcbPXs2mw3uxMCSwduQHanH+FuTTM8YNjvD9082zESM20Okw
         tw/EnAfVDD2nPcsLoB6LEr5VyXHBzRYuCzr6iR6hhulW3338LEYduJYDdPo1Cw9+qb2f
         SWWKwZJJ1HSBWMoLGYm70EuodJY+7GeB5gKI7awkFXbs7qz8YJqi5jE/CyqPXz6EQc23
         1zDg==
X-Gm-Message-State: AOAM533SjBS9tWZGFgpcU1tS631IUJ0raa+FpfWBshBXaUjpWNXqhrtB
        ne57wD1vq1reXHAXNkEybnk=
X-Google-Smtp-Source: ABdhPJz+K3FmpZm55Q8/tk6m9ooYqtD8sxkwJ/ENnVxN7tmRMQ8zK3D+xFlyXPM0GiV2Ox/wea3vBQ==
X-Received: by 2002:a17:902:a38e:: with SMTP id x14mr9715746pla.231.1595960607987;
        Tue, 28 Jul 2020 11:23:27 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z11sm19611000pfg.169.2020.07.28.11.23.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jul 2020 11:23:27 -0700 (PDT)
Date:   Tue, 28 Jul 2020 11:23:26 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/86] 4.19.135-rc3 review
Message-ID: <20200728182326.GB183563@roeck-us.net>
References: <20200728153252.881727078@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728153252.881727078@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 28, 2020 at 05:51:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.135 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Jul 2020 15:32:32 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Guenter
