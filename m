Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D09F10B88
	for <lists+stable@lfdr.de>; Wed,  1 May 2019 18:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfEAQoy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 May 2019 12:44:54 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:33460 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726224AbfEAQoy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 May 2019 12:44:54 -0400
Received: by mail-pf1-f195.google.com with SMTP id z28so3539619pfk.0;
        Wed, 01 May 2019 09:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=N7Q/cdeEz3tcslStG5dVBmwy8YOgQ6YgsvAiswu89JM=;
        b=Icz7rQb1bHfEfFK8bhL9lZKb5slw6jMORBqSjJ6VNM+POfB8/ZEynwLf/Peq81J/s/
         mTN7mUE1jw4wXs/4IVk0/PZWBBQFMzTLZstw7spmCGDZTswrci5hsFrIgEdBEnIzao63
         9OLh7EY8WDeElzWZemeG2PU9buIzSMe41IspJf1V27NV4thNIlUBtO4OqOCN7T8L7UfV
         DRoLNGdYq2xankflsfOpFsYUhRQ/uS1v7oit40cpZRKuHgZgAmrACWlJ8F4XWgnpjO9I
         Q/GtlNZjWYAduMKgRkeZjhNFMPBqdkvgKEKyeMUZCdmcS0Zy1ods+QYPoMy/VTKpmpfy
         c53A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=N7Q/cdeEz3tcslStG5dVBmwy8YOgQ6YgsvAiswu89JM=;
        b=FkslncmZo3SsJ3Iuf+gI0gDEp/7LSPCFqQee4AQB9+PGvJzJywhv363zCWV2siGV9n
         Co36BkzouV0A+8YJzy98CzCWom9HLzu7IH8Wvqv/vTG2eaG6hTfjQ75qZAMsVVjkdVvi
         ObfKxJwNw5eaXiDRMH20TTSa/fEksQvfn9TJJbNXwL0ZN2bhn2yNn+O7lS/DQeQU3vyA
         2XQsra/uoyTFeqllnSaaQaCKLwbn+rD9mOFZ2BFmtXc1NUj6V5aWgSVaJLB2dhVpr1uK
         Ja4KZHiTvBPU3w6gEFgRn0a5QTjkaNqKNBccKpX/IYiAlqrydGUd3MDBRobv17aUK57z
         r8Sw==
X-Gm-Message-State: APjAAAWAfStw8eZMSRuvQPpR9jlkiJVhOulfDE0M+6UWQZyYb6qe+GHC
        cVMW/P3COVdJYmO/KpGrZrk=
X-Google-Smtp-Source: APXvYqwvvXMyeUWUelvbICwBBZFygPysFbEASrDW6kFxmlMGFMYwEMIP7H5Ngn8adbz7cP3Fk+Xejg==
X-Received: by 2002:a63:4558:: with SMTP id u24mr71558308pgk.225.1556729093814;
        Wed, 01 May 2019 09:44:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j22sm52106940pfn.129.2019.05.01.09.44.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 01 May 2019 09:44:53 -0700 (PDT)
Date:   Wed, 1 May 2019 09:44:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.0 00/89] 5.0.11-stable review
Message-ID: <20190501164452.GD16175@roeck-us.net>
References: <20190430113609.741196396@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 01:37:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.0.11 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu 02 May 2019 11:35:03 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 349 pass: 349 fail: 0

Guenter
