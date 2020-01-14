Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4F7E13B242
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 19:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727092AbgANSlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 13:41:47 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:40097 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbgANSlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 13:41:47 -0500
Received: by mail-pj1-f67.google.com with SMTP id bg7so6255626pjb.5;
        Tue, 14 Jan 2020 10:41:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=s4kzfvQuAUG/YkKLjqJV+os6xxA9F6Z1Rb8ieNlktis=;
        b=U4HXgPEOKpAIOcCUy1Gv+sMDpQM1cb7DPhAbd9ElDkTn4oPyKxt2vvGuLzffSXoF/K
         fBnmNeqxurIx6isgAdaNIntzt24TopOxkMydM+K92BinpIhm92zcVJk6yXmCbIxRT/ux
         kLN81Ru07SChNWtqadSB3suS1xufk9e2XIslNla+0cU9xpcDCesI6edwXs6DBJnqzkfr
         KszEv64QNnHPaXzQcOnrm0+2W0WMYyYKKTS8Xqu4y6E1IhoLEYGlvF0ieEgazkOlxICk
         iH3nBZcSrar2DNihEO5RElP622pgWnUROi+RZw6maxBQmRW5AejOZiP9/gflldwBULMs
         Vf8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=s4kzfvQuAUG/YkKLjqJV+os6xxA9F6Z1Rb8ieNlktis=;
        b=CVsNExDTLqno3uDhatwEg7X68P35lKPY71jQ3xBGVsaEyWmcTixhTVG6bsOnpPBpGp
         6Q3Zg0yvtp4js2K08UFQqsFR7m+iGLXsBSP3MnJ7nX8Wglf0b6AMfXXvO9yPB1kkjwve
         tbuh/0s1uT3fCRB9jmW8KENdSB19tMbrXitBzn5ujv9bzaDROZiuZSVS8tiSez7hyZpM
         DYbQSl+Ug1wo50v8+AmH74CRQ7+sekHtZugcDMjc8pO3JQq07gfw8jpFxNM0Y2oeEEZW
         LK5KIBWuZV6RcGQFuEc7iSlCYTXAbKOk2qygitdPQzEF+rD2XXFYnqgeU1Gns3jHRRKi
         sxTw==
X-Gm-Message-State: APjAAAXEWDRcKaiVcjPVH9KXxUcvBm2YDFnt0isWbyEIyQXlrDo5oNvT
        /l8WtIFZbB8P2XxkxaLhwQ/y1ap5
X-Google-Smtp-Source: APXvYqy7ECMc97rCEZhONpFA5RqWE99HgvdVrrT5yJ+R2GM559pBaNPkBmea3TTi8RBZL+sdPab4iA==
X-Received: by 2002:a17:902:aa85:: with SMTP id d5mr28455967plr.16.1579027306414;
        Tue, 14 Jan 2020 10:41:46 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id v5sm18485413pfn.122.2020.01.14.10.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Jan 2020 10:41:45 -0800 (PST)
Date:   Tue, 14 Jan 2020 10:41:44 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/31] 4.9.210-stable review
Message-ID: <20200114184144.GA20450@roeck-us.net>
References: <20200114094334.725604663@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200114094334.725604663@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 14, 2020 at 11:01:52AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.210 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Jan 2020 09:41:58 +0000.
> Anything received after that time might be too late.
> 
Build results:
	total: 172 pass: 172 fail: 0
Qemu test results:
	total: 358 pass: 358 fail: 0

Guenter
