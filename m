Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B6D20E4E2
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730855AbgF2VaL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:30:11 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:51522 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726978AbgF2SlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Jun 2020 14:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593456082;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CkBsRTU3NLnLOCtZABIJSi326dv/G4KE311OeelG590=;
        b=GLZKp7oOzPyxe1jz6YETADttW9FRFacZnwfAXPnkXEKIW1v79q8ldEMoswSK+i7bUUVu9y
        5/RXdmWFcTNgodWug7RU+WfSfDiajT3SwuBnIFoTlbrxFYi6pfdqBH1hC+h9e54SO9MDDW
        0tQssO0AEaCeTwpr0z1+Zh5yBKCaUi0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-PxlUawicPrKyo7-miOyCiw-1; Mon, 29 Jun 2020 07:40:07 -0400
X-MC-Unique: PxlUawicPrKyo7-miOyCiw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 20A62102;
        Mon, 29 Jun 2020 11:40:06 +0000 (UTC)
Received: from localhost.localdomain (ovpn-12-123.pek2.redhat.com [10.72.12.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2CB215DC1E;
        Mon, 29 Jun 2020 11:40:03 +0000 (UTC)
Subject: Re: regression: blktests nvme/004 failed on linux-stable 5.7.y
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-nvme@lists.infradead.org, chaitanya.kulkarni@wdc.com,
        stable@vger.kernel.org
References: <1528690896.32343478.1593229315244.JavaMail.zimbra@redhat.com>
 <1015661434.32401219.1593424943236.JavaMail.zimbra@redhat.com>
 <20200629105939.GA3362395@kroah.com>
From:   Yi Zhang <yi.zhang@redhat.com>
Message-ID: <ec706623-76ac-bb87-8591-869b3844f237@redhat.com>
Date:   Mon, 29 Jun 2020 19:40:00 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200629105939.GA3362395@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 6/29/20 6:59 PM, Greg KH wrote:
> On Mon, Jun 29, 2020 at 06:02:23AM -0400, Yi Zhang wrote:
>> Hello
>>
>> commit[1] introduced regression that will lead blktest nvme/004 failed on v5.7.5, and commits [2] fixed this issue on latest linux tree.
>> But commit[2] cannot be directly applied to stable tree due to dependceny[3], could you help backport the fix and dependency to stable tree, thanks.
>>
>>
>> [1]
>> 64f5e9cdd711 nvmet: fix memory leak when removing namespaces and controllers concurrently
>>
>> [2]
>> 819f7b88b48f nvmet: fail outstanding host posted AEN req
>>
>> [3]
>> 1cdf9f7670a7 nvmet: cleanups the loop in nvmet_async_events_process

Without it, the other patch cannot be applied directly on stable.
yes, we can backport them without bellow patch, I also found they 
already queued up, sorry for the noise.

>> 696ece751366 nvmet: add async event tracing support
> Why is this last commit needed?
>
> The other ones are already queued up in the current queue, thanks.
>
> greg k-h
>

