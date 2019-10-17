Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61157DB574
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438165AbfJQSEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:04:35 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:33969 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437870AbfJQSEf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:04:35 -0400
Received: by mail-pg1-f193.google.com with SMTP id k20so1809123pgi.1;
        Thu, 17 Oct 2019 11:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7sdkter4zbQZc5I4NSPSjEieT9TKLr5i9JTfABCcVCg=;
        b=otItM5RJsrlPIHvMK47Tyx2I79v2eUC3xXKElJdZZJhy3MCo4YmpfKye51LXOEJ0N2
         O4XXrCVdhXro0+vYBC9vze/q98Pb6GUKYNNmkOYZHZ7fPM9EDHd48YfPALZADCRbTskC
         5svFhuU4SXedcRhvFmoUP++fsUQ/RrbTXX83tyHWleb0eVSMLCjdD5rpCXNKnm7kvkme
         pdqviCFpk85ZklhwhgqJfk2Osh+wFEIj2/CJUEYPOJDjTDptWZrfehCByqg2XsVJoq37
         J3vjVX6ipWCTxZ4g3D6bpV4czMCw7IvDbqeWByrm5k9t9RyaLveNU34d2Xg6XiXokmR2
         ypsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7sdkter4zbQZc5I4NSPSjEieT9TKLr5i9JTfABCcVCg=;
        b=OjTwXW4JdJyEGEfys84ebKFhHFjk3yhHIm7bvLjN7oGwxLU5iBljzsQ2NibRIefPXq
         kQzw1zTWYJkQ81CePOUATmISo8cblODjoDoPA/PtOPlQBdNEUxhi45ljS6WdjAajNmRr
         MIgV7CeYoOxguBYsAkLB2RxBpQosltYeR6d6Y/ydyziIIiYkEI5GM3DdZVGHi03hEkeS
         jBqW4O/hgX/zzt1AVrbjJWcErLrEn1xTmOcZYXmbxmvekUyQlslcvIhWmcs+uQsHkRQm
         wc8i8OL8FbAgdJ3aIYhpxo2Dcetnw5UeBjbiikNqFSijKxCVxAIJx1ZkaX7jnfKfwVhP
         8x2Q==
X-Gm-Message-State: APjAAAWn9pjHcIyHW78+slpM7xZWNxgNr8zZaXG4lzn1Q3otFO5TVYTE
        4HlSPvbyrgbk3s8vAgTW0+M=
X-Google-Smtp-Source: APXvYqz1zFPotbkED71a2G01YW0gmaejreaDh4JNRIzbj6UAJz9mtEmpF1x4QReKSZFgQ0soWqFu1g==
X-Received: by 2002:a17:90a:b946:: with SMTP id f6mr5619515pjw.69.1571335474348;
        Thu, 17 Oct 2019 11:04:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d1sm3803190pfc.98.2019.10.17.11.04.33
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 11:04:33 -0700 (PDT)
Date:   Thu, 17 Oct 2019 11:04:32 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.3 000/112] 5.3.7-stable review
Message-ID: <20191017180432.GE29239@roeck-us.net>
References: <20191016214844.038848564@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:49:52PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.3.7 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 158 pass: 158 fail: 0
Qemu test results:
	total: 391 pass: 391 fail: 0

Guenter
