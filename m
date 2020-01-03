Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B120212FCDC
	for <lists+stable@lfdr.de>; Fri,  3 Jan 2020 20:09:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728383AbgACTJm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jan 2020 14:09:42 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:23302 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728373AbgACTJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jan 2020 14:09:42 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578078581;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:in-reply-to:in-reply-to:  references:references;
        bh=Mi+p+XgkDLMfGQNM+tJDQI6d+aqqQMXlBNSJj/pQl2Y=;
        b=LW4IuqCKfOiImsQi14LJ1/d4aqqUmFonxvROYLQNYPvrxfavbROlPqgnJkimKCIlEvwuF1
        KpXLOUZWLGQtcK4BKKEfO2LbkVFdacHwjNvtNZ2XGDKWGQPedDhvGXNkjrGdoZSP7aLgks
        5UiDsL7IlYUoVrgAm4Iyq6EcgoHtVjw=
Received: from mail-yw1-f69.google.com (mail-yw1-f69.google.com
 [209.85.161.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-101-IHw8zGeZN6uVjofoXjWDhQ-1; Fri, 03 Jan 2020 14:09:38 -0500
X-MC-Unique: IHw8zGeZN6uVjofoXjWDhQ-1
Received: by mail-yw1-f69.google.com with SMTP id u199so27830954ywc.10
        for <stable@vger.kernel.org>; Fri, 03 Jan 2020 11:09:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=Mi+p+XgkDLMfGQNM+tJDQI6d+aqqQMXlBNSJj/pQl2Y=;
        b=QHbejnAt08Y+LFZbGG+m1HgioYq8xZpnZsod2+Nh7LzoB0vviw7GSVyk47+Qzq56Bd
         acOmYSz9Y8sVJcmbQ4ajpI9/QEDRRyLBvC/x86etPYhm/CJESbDVvBVmtumPV/DyL+BS
         lD6StKwKBP18JREw1UemzBc/Z1+mlnjL2fYzjEa8N3X0D+oNOZ+qTxZ1EP/v0mQk5eTV
         3W7Cn6bs2xPvLJHpBJD96V/G8g7hPs/edVs0H8eCrdH8ZH5AqwklutYpxkwzslGYyRjP
         YD5y1jGeGCkFth6/k4g+PIABYA6IrjtgzkxFF4uni4JLxAXb9A5strcmVm23CwPRyTXy
         CQCQ==
X-Gm-Message-State: APjAAAVOfqmXt3GDiu5x0uUfcPeN5XbQsslevpe8qRbqOt5BK+vqdUUP
        k0IAi3Fs7EJr8V/2r+RzzZmHr9JHcLDekhrQyo3hjMD8s8qexmUCn89np9gkPrpTTU2qGOLmo6I
        nd9ExV2xNktx+eVBI
X-Received: by 2002:a25:508:: with SMTP id 8mr54774795ybf.18.1578078578493;
        Fri, 03 Jan 2020 11:09:38 -0800 (PST)
X-Google-Smtp-Source: APXvYqzcgl0UlQ1U9iM6U8Ycl3qLNG3u1tlA+J3sW0sRGH+D5J4oCWZdJYeIQK8iYwS+cMT5CuQOTA==
X-Received: by 2002:a25:508:: with SMTP id 8mr54774780ybf.18.1578078578212;
        Fri, 03 Jan 2020 11:09:38 -0800 (PST)
Received: from localhost (ip70-163-223-149.ph.ph.cox.net. [70.163.223.149])
        by smtp.gmail.com with ESMTPSA id p1sm25467653ywh.74.2020.01.03.11.09.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jan 2020 11:09:37 -0800 (PST)
Date:   Fri, 3 Jan 2020 12:09:35 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Matthew Garrett <matthewgarrett@google.com>
Cc:     linux-integrity@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Matthew Garrett <mjg59@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH V2] tpm: Don't make log failures fatal
Message-ID: <20200103190935.yol52xqjg7f6js7k@cantor>
Reply-To: Jerry Snitselaar <jsnitsel@redhat.com>
References: <20200102215518.148051-1-matthewgarrett@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
In-Reply-To: <20200102215518.148051-1-matthewgarrett@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu Jan 02 20, Matthew Garrett wrote:
>If a TPM is in disabled state, it's reasonable for it to have an empty
>log. Bailing out of probe in this case means that the PPI interface
>isn't available, so there's no way to then enable the TPM from the OS.
>In general it seems reasonable to ignore log errors - they shouldn't
>interfere with any other TPM functionality.
>
>Signed-off-by: Matthew Garrett <mjg59@google.com>
>Cc: stable@vger.kernel.org
>---

Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

