Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D634F27572
	for <lists+stable@lfdr.de>; Thu, 23 May 2019 07:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfEWF0J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 May 2019 01:26:09 -0400
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42034 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725806AbfEWF0I (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 May 2019 01:26:08 -0400
Received: by mail-lj1-f196.google.com with SMTP id 188so4187815ljf.9;
        Wed, 22 May 2019 22:26:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=2zCsyXvXKQNDrlDAaTPYsiKB9L/0GPY7IwNwkSTGIws=;
        b=Ta9mRdKZaIppt1lVoJqu6fTlJpOePKt8UpD0P1KlB+5Dhq5IRFRgjf30yH3w11W0Rz
         YEOutIeR2eVbTVwwM8xE3TG1Vw0rLpHI7yHMe9wcgF24eWV6mrZTEbwCl2QDJ78Tq7sS
         lgH1nF185LcEsLWnvD3WzxR0BfM5VB26/nckreMvZB1LkZvhNTYp67QtaOeA4auI3qSV
         ariGldx5mrqJSCxVgiZVcVyyLMQPSTwKpJaSV2UceiNy8Ghuy+BjmPZFZNSqV/Pppv/S
         KyuoB7s00FCTXWyMy8Gp1LXYFNh8dalME8JNdybe9xzB94j0j1BzAAVi6+LEI6YiQCtk
         NRhQ==
X-Gm-Message-State: APjAAAVmJ0K2kf1riWIKV/jpH/NMT1GSMt2qQyPq/46QuAcnSdHhea2k
        LPxNW1FoM0hSmodbVTpviw5PF35pidc=
X-Google-Smtp-Source: APXvYqyA+ouMbSVPDNeED1P3R2zPHpVIba71XK7OdTwYvUvWtpyQh9fTIn1geqaP7SOnZMdVP0vS5Q==
X-Received: by 2002:a2e:9259:: with SMTP id v25mr4076631ljg.46.1558589166763;
        Wed, 22 May 2019 22:26:06 -0700 (PDT)
Received: from xi.terra (c-74bee655.07-184-6d6c6d4.bbcust.telenor.se. [85.230.190.116])
        by smtp.gmail.com with ESMTPSA id p5sm5818207lfc.80.2019.05.22.22.26.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 May 2019 22:26:05 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.91)
        (envelope-from <johan@kernel.org>)
        id 1hTgEq-00043C-Ic; Thu, 23 May 2019 07:26:01 +0200
Date:   Thu, 23 May 2019 07:26:00 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan@kernel.org>, linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.1 077/375] USB: serial: fix initial-termios
 handling
Message-ID: <20190523052600.GA15348@localhost>
References: <20190522192115.22666-1-sashal@kernel.org>
 <20190522192115.22666-77-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190522192115.22666-77-sashal@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Wed, May 22, 2019 at 03:16:17PM -0400, Sasha Levin wrote:
> From: Johan Hovold <johan@kernel.org>
> 
> [ Upstream commit 579bebe5dd522580019e7b10b07daaf500f9fb1e ]
> 
> The USB-serial driver init_termios callback is used to override the
> default initial terminal settings provided by USB-serial core.
> 
> After a bug was fixed in the original implementation introduced by
> commit fe1ae7fdd2ee ("tty: USB serial termios bits"), the init_termios
> callback was no longer called just once on first use as intended but
> rather on every (first) open.
> 
> This specifically meant that the terminal settings saved on (final)
> close were ignored when reopening a port for drivers overriding the
> initial settings.
> 
> Also update the outdated function header referring to the creation of
> termios objects.
> 
> Fixes: 7e29bb4b779f ("usb-serial: fix termios initialization logic")
> Signed-off-by: Johan Hovold <johan@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

The stable tag was left out on purpose as this is essentially a new
feature, and definitely a behavioural change which should not be
backported.

Please drop from your autosel queues.

Also, may I ask you again not to include usb-serial (and drivers/gnss)
in your autosel processing.

Thanks,
Johan
