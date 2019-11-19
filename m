Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F7A6102E8E
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 22:47:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727007AbfKSVrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 16:47:46 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:45492 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727082AbfKSVrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Nov 2019 16:47:46 -0500
Received: by mail-qk1-f194.google.com with SMTP id q70so19331126qke.12
        for <stable@vger.kernel.org>; Tue, 19 Nov 2019 13:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ExsRy761fR+NtR7WrC6yeAFdYPFiJLMFT88ufVbVWdo=;
        b=IfmA2Re/C0iHXEBLHu9wEnqe48JjyG5b8tUGIdW1aoSkfOFcLy0rlppWpEPhEEQaC7
         SpS+0d1gjUkLgGKAP9CwX4b5lSjTb+IDb2oKttpIKWsSH/MDF+5HbAOZIicGkZT7N/NL
         eoC5ubKA5skObiddiSmBiuqiLABIHzeUbzy5E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ExsRy761fR+NtR7WrC6yeAFdYPFiJLMFT88ufVbVWdo=;
        b=BTaAvdJXXoo01GdlM+LSJ/UOdDRkUyX/I48ZODb7cBXK0C1oRZvbkfvQQ8aHdq1zRl
         KIxlhL6V5Dp29WjY4kFAKI/xN6fjprtUHZtFSALb2mUXpfv+Lb2i0g1cSb5Lb/kVwx4j
         zAXTHvA0IjzNYHQKvECfy2QN0Id5RNPnQM8WGYo8SWHXl2PPkxBx5GXtgebqY1o8Opnv
         PRsBc8YnPIjHCdqRWc0C+6tx2bVSYPIH/YST962x+TYDrhRpuNiQwfCA3jejpywq0p0B
         sVxwBttUAHqsesMtLrSvXRtYWUbccA8A8XJIuRutitXk6OvmVAbeAtTArTNx30OucxLf
         4xQg==
X-Gm-Message-State: APjAAAU2gbtajvK/CTtrH3EgnivYfBNK5f1R7aPE3ppSZeaZV/HA69a7
        oUzNnc3TeyHA9OFYwYca8r4dERaOnacpvQ==
X-Google-Smtp-Source: APXvYqwZj1BNnKGsI0bmk/7BFM60y6EpoBgCiSJx3fK5MzYN/xfJwFf6EYVfpcGGyAeO8n4V1uB/wg==
X-Received: by 2002:a37:d8e:: with SMTP id 136mr18311038qkn.249.1574200064946;
        Tue, 19 Nov 2019 13:47:44 -0800 (PST)
Received: from chatter.i7.local (107-179-243-71.cpe.teksavvy.com. [107.179.243.71])
        by smtp.gmail.com with ESMTPSA id x1sm12610414qtf.81.2019.11.19.13.47.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 13:47:44 -0800 (PST)
Date:   Tue, 19 Nov 2019 16:47:42 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH website] releases: Extend 3.16 EOL to match Debian 8
Message-ID: <20191119214742.f6do77hyjrme3m3z@chatter.i7.local>
References: <20191119213141.GA19244@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191119213141.GA19244@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 19, 2019 at 09:31:41PM +0000, Ben Hutchings wrote:
> I'm maintaining 3.16 primarily for Debian 8.  I originally expected
> that to have an EOL of April 2020 but it's actually June.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>

I'll let Greg apply this.

Acked-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>

-K
