Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F5B2E98F5
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 16:38:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbhADPiX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 10:38:23 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34865 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727529AbhADPiW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Jan 2021 10:38:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1609774616;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Wcrw+NpZAZ4cyYiYlRnmiZrkDJtugvQ8JiKGHsSokGg=;
        b=STCbTgGK7KaTRa7jNH0iTo72wt4zLgYWo6krWAf8AdhHGfLo2RDXzT/YYAh6Nt9BZ853Na
        qPYsNRjU3DLn/cfzkxFZl4qS1/5MDxhfvl8hFinIFWFSJfh9UZgtMnQhtx+wNtn5MNOpfg
        KUdF+voe5RAQdD8iCbVGM0eDl6+sbEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-567-aFEXv2VNOQ2AdcHHwmbh5g-1; Mon, 04 Jan 2021 10:36:54 -0500
X-MC-Unique: aFEXv2VNOQ2AdcHHwmbh5g-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 81D7EBBEE0;
        Mon,  4 Jan 2021 15:36:52 +0000 (UTC)
Received: from [10.36.114.59] (ovpn-114-59.ams2.redhat.com [10.36.114.59])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C5E3271B0;
        Mon,  4 Jan 2021 15:36:51 +0000 (UTC)
Subject: Re: [PATCH v1 1/4] s390/kvm: VSIE: stop leaking host addresses
To:     Claudio Imbrenda <imbrenda@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org, borntraeger@de.ibm.com,
        frankja@linux.ibm.com, kvm@vger.kernel.org,
        linux-s390@vger.kernel.org, stable@vger.kernel.org
References: <20201218141811.310267-1-imbrenda@linux.ibm.com>
 <20201218141811.310267-2-imbrenda@linux.ibm.com>
 <b1a31982-a967-7439-1a7c-3c948deeb79d@redhat.com>
 <20210104145802.7a2274a2@ibm-vm>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat GmbH
Message-ID: <4d7ea3de-61b7-af89-a3d4-5a4b5749f667@redhat.com>
Date:   Mon, 4 Jan 2021 16:36:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210104145802.7a2274a2@ibm-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>> In that case, it's pretty much a random number (of a random page used
>> as a leave page table) and does not let g1 identify locations of
>> symbols etc. If so, I don't think this is a "clear security issue"
>> and suggest squashing this into the actual fix (#p4 I assume).
> 
> yeah __maybe__ I overstated the importance ;)
> 
> But I would still like to keep it as a separate patch, looks more
> straightforward to me
>  

I don't see a need to split this up. Just fix it right away.


-- 
Thanks,

David / dhildenb

