Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B8E9C835A6
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbfHFPt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:49:58 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:33195 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728041AbfHFPt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Aug 2019 11:49:58 -0400
Received: by mail-pl1-f196.google.com with SMTP id c14so37955257plo.0;
        Tue, 06 Aug 2019 08:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ISJk7lgiNbRFQ9dri6oC21EdisQH+FQocy/MpzvxAvQ=;
        b=PiI5ZNE2OWZ0yR/JPlT73OB/lobSy4Da8KstILb2/yiZDLvfBxDRIur20CUFQ8xBio
         6ThAk3tNzHf+WDePYgU5tQ6Pws+DaXkSdc0cnEyZ6VPMy3/GdmXOmv4kEcXKdHh/lvR9
         ko1Tq35X1oforajAhUcBSlZQZStnRBHLeuG3Ju5jFpsa2sGTK5NLl36wN1vtJ/qr5rla
         ux6UQ07Tqu/9XQLZmzdgY46NTvBb0QHuxyf7HQaeCt14WI/5wpvnH1ZOeWy089yveOJI
         f8sO161/BIszPB9M3P/PHgiFco/p05NOoUMFU0LYcBxisr/TCXZOwcGZjbLAvucCqALm
         zY1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=ISJk7lgiNbRFQ9dri6oC21EdisQH+FQocy/MpzvxAvQ=;
        b=hZvA55nr6GbHOqJPBgfxwA4w2WEL3Y2fHiI1eOt1UsXuKr6KBGeASjycP3hx2fFVlV
         b4iFHvMmwQe0pjXyR316TYhmH0iQWL5ZKhbaBV2/ing4pLBosHSHZf2amzcaZfw+6bhF
         2fzuqUe7JLH4TMWJZ13Ft9JJ8ofQwtxNKDac4xptAMdgnS4JZIa/s5xl3ex15ytLP0up
         2iJG5NEifpMycckH+pBCmxSwHMnaU9ewqWJI9J+zfuQ0X+ZyVKOMRe2cn0hxNcpExnnr
         HtsggFXM+Y+lBjCWWj6pFkSslKM0E6qm2rtFJGuM6Qaksw/QyhHmL/1jErZe6QCO1G+m
         BQdw==
X-Gm-Message-State: APjAAAU50ugyP/WiXTAINSxnP0BKRM4H5cxDihCG+ZY5r90Mit6XvCD9
        9IQ6qfNM4NCOTnlPFeoXhGI=
X-Google-Smtp-Source: APXvYqwcnxvfjH+NHxGEUsObqZqmQUPOgkO1dkFGzv89H9SFlXrG8F6FkuzKq1+0U78SZsDMoTT9LQ==
X-Received: by 2002:a17:902:8689:: with SMTP id g9mr3566411plo.252.1565106598012;
        Tue, 06 Aug 2019 08:49:58 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p68sm101455706pfb.80.2019.08.06.08.49.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 06 Aug 2019 08:49:57 -0700 (PDT)
Date:   Tue, 6 Aug 2019 08:49:56 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/74] 4.19.65-stable review
Message-ID: <20190806154956.GD12156@roeck-us.net>
References: <20190805124935.819068648@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190805124935.819068648@linuxfoundation.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 05, 2019 at 03:02:13PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.65 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Aug 2019 12:47:58 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 364 pass: 364 fail: 0

Guenter
